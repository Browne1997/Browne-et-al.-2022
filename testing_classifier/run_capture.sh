# Run in bash terminal window as follows:
bash run_capture.sh

#Notes:
# Comment out line with '#; depending on using vieo or livetsream

# Synthetic ship set-up: run on video
CAM_STUFF="-video_size 1920x1080   -i /video/directory"
# In-situ set-up: run on livestream
CAM_STUFF="-video_size 1920x1080   -i /video/directory"

# working h265 hardware encoded
# -g 1 reference frame every one
# -r 2 2 fps output rate  BUT not needed - the fps filter does it once for all streams
# -b:v 20M   20m video output rate

OUT_STUFF="-vcodec hevc_nvenc -preset medium -profile:v main10 -level:v 6 -g 1 -b:v 20M  -f rtsp"

# in a filter  x,y,z chains x's output to y's input and so on
#  a;b;c declare independent chains
#  [p]X[q] says X takes name stream p as input, generates q as output

# crop parameter is w:h:x:y,  x and y are top left corner, and 0,0 is top left of frame
# we have integer math.
# the mid x is cryptic - easier as (iw/2) [centre of frame] - (704/2) [half output width]

# need a way to make a multi-line, readable string into a single parameter to ffmpeg
# source: https://stackoverflow.com/questions/46807924/bash-split-long-string-argument-to-multiple-lines

SPLIT_FILTER="[0:v]bwdif=mode=frame,fps=fps,split=[s1];\
[s1]scale=1920x1056[o1];\

# the single rtsp server will serve three streams, left, mid, right

# hack attack "X" will remove the \newlines in the string
ffmpeg $CAM_STUFF  -filter_complex  "$SPLIT_FILTER" \
       -map '[o1]' $OUT_STUFF  rtsp://localhost:8554/whole 
