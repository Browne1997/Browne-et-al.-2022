# -*- coding: utf-8 -*-
"""
Created on Wed Oct 13 13:10:14 2021

@author: Erinb
"""

# Python to manipulate training and test data in YOLO format for Darknet
#Import packages 
import cv2
from collections import defaultdict
import random 
from pathlib import Path 
import numpy as np 

''' Create train and test data for training yolo. Skipping VIAME API'''
def letterbox_image(image, expected_size):
  ih, iw, _ = image.shape
  eh, ew = expected_size
  scale = min(eh / ih, ew / iw)
  nh = int(ih * scale)
  nw = int(iw * scale)

  image = cv2.resize(image, (nw, nh), interpolation=cv2.INTER_CUBIC)
  new_img = np.full((eh, ew, 3), 128, dtype='uint8')
  # fill new image with the resized image and centered it
  new_img[(eh - nh) // 2:(eh - nh) // 2 + nh,
          (ew - nw) // 2:(ew - nw) // 2 + nw,
          :] = image.copy()
  return new_img
# False on Linux and True on windows
if True:
   path_1 = tuple(Path("D:/deint_frames").glob("**/*.png"))
   folders = Path("D:/deint_frames/resize_images") # create the new folder for resized images
   weights = Path("D:/deint_frames/weights")
   # yolov3 = "./yolov3.cfg"
else:
   path_1 = tuple(Path("D:/deint_frames").glob("**/*.png"))
   folders = Path("D:/deint_frames/resize_images") # create the new folder for resized images
   weights = Path("D:/deint_frames/weights")
   # yolov3 = "./yolov3.cfg"
   
for folder in (folders, weights): # list with one memeber > (X, )
   Path.mkdir(folder, parents=True, exist_ok=True)

''' Create files/folders required for training classifier using Darknet'''

with open ("xenos.lbl", "wt") as xenos_label:
   print("""xenos
""", file = xenos_label) 
   xenos_name = xenos_label.name
   
def extract_bboxs (d, width=1920, height=1080, output_aspect = 1.0): # d = directory path
   csv = d.parent/d.name.replace('_frames','_v.csv') # find GT csv as a Path 
   xenos = defaultdict(list)
   print(f'{d=} {csv=}')
   input_aspect = width/height 
   height_sf = output_aspect/input_aspect
   with open (csv,'rt') as annots: 
      for l in annots: # --skips over header0 line 
         if l.startswith('#'):
            continue # --
         fields = l.split(',')
         if fields[9].strip() != 'OTU261': # pick up lines in csv that are only xenos
            continue
         x1,y1,x2,y2 = map(int, fields[3:7]) # extra columns from csv (i.e. fields)
         xenos[fields[1]].append (f'0 {(x1+x2)/2/(width-1)} {(y1+y2)/2/(height-1)} {(x2-x1)/2/(width-1)} {(y2-y1)/2/(height-1)*height_sf}') # hard-code class {sclaing of image}
   return xenos

   
with open ("xenos.data", "wt") as data_file:
   print(f"""classes 1
names = {xenos_name}
backup = {weights}
""", file = data_file)
   data_name = data_file.name
   
   with open("train.txt", 'wt') as train_list, open("test.txt", 'wt') as test_list:
      print(f"train = {train_list.name}", file = data_file)
      print(f"valid = {test_list.name}", file = data_file)
      known_csv = {}
      total_xenos = 0
      csv_counts = defaultdict(int) # dictionary of mapping filename to xenos number in file
      for p1 in path_1:
         # print(p1)
         dirs, filename = p1.parent, p1.name
         if dirs not in known_csv:
            known_csv[dirs] = bbs = extract_bboxs(dirs) # take known csv from dictionary  
            for xeno_file, xenos in bbs.items():
               csv_counts[xeno_file] += len(xenos) # items go to dictionary returning a key and value
               total_xenos += len(xenos) # total xenos in all files (images)
            
      # Then perform random permutation of images and until xenos count = 20% of total
      all_files = list(x.name for x in path_1)
      random.shuffle(all_files)
      # Create training and test files as sets > have faster membership test
      train_files = set() 
      test_files = set()
      xenos_target = total_xenos*0.2 # 20% test set
      for f in all_files:
         xenos_here = csv_counts[f]
         xenos_target -= xenos_here
         if xenos_target < 0: # two sets of test and tain files creates
            train_files.add(f)
         else: 
            test_files.add(f)
      print (f'{len(train_files)=} {len(test_files)=}') # prints out an evaluation of the formatted string i.e. check if the ratio is 0.2:0.8 
         
      for p1 in path_1:
         # print(p1)
         dirs, filename = p1.parent, p1.name
   
         # Create the annotation.txt file 
         with open ((folders/filename).with_suffix('.txt'), 'wt') as groundtruth:
            if dirs not in known_csv:
               known_csv[dirs]= extract_bboxs(dirs) # take known csv from dictionary  
            for xeno in known_csv[dirs][filename]:   # searches by filename to find xenos instances 
               print(xeno, file = groundtruth) 
        
         # Split into train and test folder 
         if filename in test_files: 
            print(folders/filename, file=test_list)
         elif filename in train_files:
            print(folders/filename, file=train_list)
         else: 
            raise ValueError(filename) # Check if any files have not been assigned to test or train 
         
         pngs = cv2.imread(str(p1))
         #pngs_resize = cv2.resize(pngs,(704, 704)) # or resize perserving aspect ratio - 1line change + line 50 y component
         print(f'{folders/filename=}')
         cv2.imwrite(str(folders/filename),letterbox_image(pngs,(704,704)))