#!/usr/bin/bash

set -x
#CAM_STUFF="-video_size 1920x1080   -i /dev/video3"

# deinterlace 2N fields/s to N frames/s
VID_PROC="bwdif=mode=frame"

# or, if no processing needed
VID_PROC="copy"

# -r output rate in Hz, so 0.1 is every 10s
# -t duration - here in seconds, but hours and mins also allowed hh:mm:ss

mkdir -p out_frames

ffmpeg -t 60s -i $1 -filter:v "${VID_PROC}" -r  0.1 out_frames/output_%04d.png
