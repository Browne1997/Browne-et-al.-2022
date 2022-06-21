# The following file structure is required for this to run
# In the same directory location place the following:
#   1. folder of annotated images, VIAME formatted groundtruth.csv (Fig1.B) and label.txt outlining target classes (1 class per line)
#   2. train_deep_yolo_detector_from.csv.sh - edit INPUT_DIRECTORY location to the SAME folder name of annotated images

# Then cd in into this directory and run the following line
bash train_deep_yolo_detector_from.csv.sh

# This may seem to fail but that is just the training if you check the folder again you should have the output outlined in Fig1.C
