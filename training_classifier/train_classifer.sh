# ERIN - add file structure image 
# cd into this directory ^

# Notes:
# -map: provides calculated mean Average Precision scores and average CIoU loss
# -thresh: sets the average CIoU threshold

# 1. Open bash shell terminal window
# 2. cd to the CWD with the file structure seen in diagram 2.2
# 3. run following bash script line 

# here you must edit the X's to a value of choice, insert name of classifier for both the .cfg (configuration file) and .conv.137 (weights file)
./darknet detector train data/obj.data ./classifier.cfg ./classifier.conv.137 -map X -thresh X

# OR download this whole script, put in same CWD and run:
bash train_classifier.sh
