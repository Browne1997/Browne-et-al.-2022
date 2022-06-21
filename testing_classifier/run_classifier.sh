# Run either line (video or livestream) in separate terminal after RTSP.sh and run_capture.sh scripts

# Notes:
# -prefix: saves each frame to given directory
# Rename X with personal files
# -thresh: CIoU threshold (i.e. confidence = 0.5 default)

# Synthetic ship: run classifier on video file
./darknet detector demo ./deep_training/X.data ./deep_training/X.cfg ./deep_training/models/X.weights '/video/directory.mov' -thresh 0.5 -prefix /location/for/framegrabs/name_ -json_port 6666
# In-situ ship: run classifier on livestream
./darknet detector demo ./deep_training/X.data ./deep_training/X.cfg ./deep_training/models/X.weights '/video/directory.mov' -thresh 0.5 -prefix /location/for/framegrabs/name_ -json_port 6666
