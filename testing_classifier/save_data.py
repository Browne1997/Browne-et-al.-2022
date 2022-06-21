"""
Run this script in separate bash shell terminal window in sinc with run_classifier.sh using the following line:
python save_data.py
"""
# Note ensure python version 3 is within the directory path this is ran from

import socket
from time import sleep 
from asyncio import IncompleteReadError  # only import the exception class


class SocketStreamReader:
   def __init__(self, sock: socket.socket):
      self._sock = sock
      self._recv_buffer = bytearray()

   def read(self, num_bytes: int = -1) -> bytes:
      raise NotImplementedError

   def readexactly(self, num_bytes: int) -> bytes:
      buf = bytearray(num_bytes)
      pos = 0
      while pos < num_bytes:
         n = self._recv_into(memoryview(buf)[pos:])
         if n == 0:
            raise IncompleteReadError(bytes(buf[:pos]), num_bytes)
         pos += n
      return bytes(buf)

   def readline(self) -> bytes:
      return self.readuntil(b"\n")

   #djch added
   def readlines(self):
      while True:
         yield self.readuntil(b"\n")
   
   def readuntil(self, separator: bytes = b"\n") -> bytes:
      if len(separator) != 1:
         raise ValueError("Only separators of length 1 are supported.")

      chunk = bytearray(4096)
      start = 0
      buf = bytearray(len(self._recv_buffer))
      bytes_read = self._recv_into(memoryview(buf))
      assert bytes_read == len(buf)
     
      while True:
         idx = buf.find(separator, start)
         if idx != -1:
            break

         start = len(self._recv_buffer)
         bytes_read = self._recv_into(memoryview(chunk))
         buf += memoryview(chunk)[:bytes_read]

      result = bytes(buf[: idx + 1])
      self._recv_buffer = b"".join(
         (memoryview(buf)[idx + 1 :], self._recv_buffer)
      )
      return result

   def _recv_into(self, view: memoryview) -> int:
      bytes_read = min(len(view), len(self._recv_buffer))
      view[:bytes_read] = self._recv_buffer[:bytes_read]
      self._recv_buffer = self._recv_buffer[bytes_read:]

      # print(f"{bytes_read=} {len(view)=}")

      if bytes_read == len(view):
         return bytes_read
      bytes_read += self._sock.recv_into(view[bytes_read:])
      # print(f"++ {bytes_read =}")
      return bytes_read

if __name__ == "__main__":

   import sys, json
   import csv
   from pprint import pprint
   
   HOST, PORT = "localhost", 6666
   
   from datetime import datetime
   
   with open('live_feed.csv', 'wt', newline='') as output_file,\
       open('live_time.csv', 'wt') as time_file:
      # DictWriter needs a list of keys, in a single dictionary, and the json
      # has dict nested...
      
      # set up the constant ones now
      
      out_dir = {'file': output_file.name, # changed , to : since it's a dict. djch's mistake
                 'length':  -1,
      }

      # the column headings
      keys = ['detect_id', 'file', 'frame_no',
              'tl_x', 'tl_y', 'br_x', 'br_y',
              'confidence', 'length', 'OTU', 'OTU_confidence', 'timestamp+1h']
      
      dict_writer = csv.DictWriter(output_file, keys, restval='BOGUS')
      dict_writer.writeheader()
    
      detect_no = 0
      W = 1920
      H = 1080

      # Create a socket (SOCK_STREAM means a TCP socket)
      with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
         # Connect to server and send data
         while True:
            try:
               sock.connect((HOST, PORT))
               break
            except Exception:
               sleep(1.0)

         seek_start = True      # two state state machine

         for i, l in enumerate(SocketStreamReader(sock).readlines()):
            #print(f"Line {i} {l}")
            # the code in http_stream.cpp (line 206) does a select() for readable
            # thus we must send it something after each JSON frame report, or no more are sent...

            if seek_start:
               if l == b'{\n': # cheat here - line with just { only occurs at start of frame
                               # discovered from darknet source code - not true for all JSON...
                  # print("Start of frame")
                  frags = [l]
                  seek_start = False
                  continue
            else: # JSON>python data structure 
               if l == b'}, \n': # again discovered from the source - this is end of frame
                  # we want to treat each frame as a complete JSON object, so don't include the ,
                  frags.append(b'}')
                  seek_start = True
                  try:
                      json_data = json.loads(frame := b''.join(frags)) #json_data is a python dictionary
                      print("Decoded")
                      pprint(json_data) #prints out the converted JSON to python data structure
                      out_dir['frame_no'] = json_data['frame_id']
                      if json_data['objects']:
                          print(f"{json_data['frame_id']}, {datetime.isoformat(datetime.utcnow())}",
                                file = time_file)
                      
                      for objs in json_data['objects']:
                         out_dir['detect_id'] = detect_no
                         detect_no += 1

                         out_dir['confidence'] = out_dir['OTU_confidence'] = objs['confidence'] # we only have one confidence

                         out_dir['OTU'] = objs['name']  # or could be class_id

                         rc = objs['relative_coordinates'] # for brevity...
                         out_dir['tl_x'] = int((rc['center_x'] - rc['width']/2)*W)
                         out_dir['br_x'] = int((rc['center_x'] + rc['width']/2)*W)

                         # video, not maths, so tl_y is smaller than br_y...
                         out_dir['tl_y'] = int((rc['center_y'] - rc['height']/2)*H)
                         out_dir['br_y'] = int((rc['center_y'] + rc['height']/2)*H)
                         
                         out_dir['timestamp+1h'] = datetime.isoformat(datetime.utcnow()) 

                         dict_writer.writerow(out_dir)

                  except Exception as e:
                      print("JSON not happy", e)
                      raise
                      print(str(frame, 'utf-8'))
               else:
                  frags.append(l)

               # magic to make darknet send the next line
               sock.send(b'OK')

