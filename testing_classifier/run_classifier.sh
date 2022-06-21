# Run script in separate terminal after RTSP.sh and run_capture.sh as follows:
# bash run_classifier.sh

# Notes:
# -prefix: saves each frame to given directory
# Rename X with personal files
# -thresh: CIoU threshold (i.e. confidence = 0.5 default)
# Comment out livestream or video line depending on usage

# Synthetic ship: run classifier on video file
./darknet detector demo ./deep_training/X.data ./deep_training/X.cfg ./deep_training/models/X.weights '/video/directory.mov' -thresh 0.5 -prefix /location/for/framegrabs/name_ -json_port 6666
# In-situ ship: run classifier on livestream
# 'rtsp://localhost:8554/whole -i 0' line must correspond to run_capture.sh 
./darknet detector demo ./deep_training/X.data ./deep_training/X.cfg ./deep_training/models/X.weights rtsp://localhost:8554/whole -i 0 -thresh 0.5 -prefix /location/for/framegrabs/name_ -json_port 6666

# Check it is working
ffplay -rtsp_transport tcp rtsp://localhost:8554/whole
