# Guidance and code used in publication Browne et al 2022

Author: Erin Browne and David Hutchinson 

Folders in repository correspond and include the following steps taken below

# 1. Instructions and codes used in Methods: Training data preparation

![image](https://user-images.githubusercontent.com/91316035/167623090-17f7b6c2-183b-4633-b18b-962659cc5054.png)
Figure 1| Training data preparation 

1. extract_frames_N.py: code to produce deinterlaced framegrabs at 20 secs or 1min intervals from ROV Isis video (see Fig.1A) + * Code required to run the ffmpeg section * - DAVID
2. xls2csv.py: code to transform BIIGLE annotation .xls files to VIAME .csv format (see Fig.1B)
3. viame_installation: Installation instructions for VIAME at https://github.com/VIAME/VIAME 
   * 3i. viame_pre-processing: Organise file structure
   * 3ii. Run XXXX.sh script to initiate pre-processing of the raw framegrabs for data augmentation (see Fig1.C)
4. skip_viame.py: code to produce same data outputs needed for training as VIAME without the augmentation of brightness and resolution variance (see Fig1.C)

# 2. Instructions and codes used in Methods: Training classifiers and Assessment of classifier training performance

1. darknet_compiling: Instructions to compile Darknet deep learning framework to user local machine for 1) training and 2) Real-time running
2. File structure for training on local machine should be as follows:
 FIGURE OF THIS ERIN 
3. Weights and configuration files explanation and source

Table 1 outlines where classifier architectures weights files (used for storing the parameters learnt during training corresponding to features of the target class) and corresponding configuration files (outlining classifiers architecture in terms of functions, mathematics etc.) are sourced. These weights are either pre-trained on larger imagery datasets (lower level features already learned and stored in weights file), also known as transfer learning. Or the weights have no pre-trained features, therefore all features learned and stored in the weights files are directly from the training imagery created in this study, also known as train-from-scratch. 

Table 1| Sources for weights and configuration files for training from scratch (VIAME API GitHub Version 0.15.1 (YOLOv3) and Version 0.17.2 (YOLOv4)) and transfer learning (AlexeyAB GitHub).
| Classifiers  | Weights files      | Configuration files |
| ------------ | ------------------ | ------------------- |
| YOLOv3       | https://pjreddie.com/media/files/yolov3-spp.weights and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_v3_seed.weights | https://raw.githubusercontent.com/AlexeyAB/darknet/master/cfg/yolov3-spp.cfg and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_train.cfg |
| YOLOv4       | https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137 and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_seed.weights  |  https://raw.githubusercontent.com/AlexeyAB/darknet/master/cfg/yolov4.cfg and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_train.cfg |

4. set_training: using the outlined file structure (2.2) with the produce training image datasets (1.3 and 1.5) and sourced weights and configuration files this code will instruct how to run the training process on the users local machine (source code comes from: https://github.com/AlexeyAB/darknet)

# 3. Instructions and codes used in Methods: Testing classifier performance using independent data as part of a novel pipeline for real-time ROV deployment: in-situ and synthetic ship
The following codes are highlighted in consecuetive steps to describe the process of sea deployment of a YOLOv3 or v4 classifiers to detect a target species or multiple target species.

Data outputs are individually saved frame from the darknet detector, denoting the object detected within the image is done with a bounding box and a confidence score. Additionally a .csv file is produce with every detection made and at which time within the video and frame number.

![image](https://user-images.githubusercontent.com/91316035/163668237-5125358e-afaa-41f5-8f13-0a74f53569f1.png)
Figure 1| In-situ set-up for real-time or synthetic ship to test real-time ability or to perform post-analysis on video data for faster results.

The following equiptment required:
  1. Magewell capture card inserted into computer
  2. HDMI cable therthering from ROV topside to magewell capture card
  3. Computer (minimum requirements for 25FPS detecting -12GPU VRAM)
  4. Screen
  
 The following installations required: 
  1. Magewell capture card software
  2. 


* Not deinterlacing not required (expand); if skipped video can be interpreted at XX FPS and to turn this off comment out line X in script X usng a '#' key. *

# 4. Computer vision metrics used in Methods: Calculating classifier performance in detecting areas of presence-absence and individual counts S. fragilissima

- Recall (sensitivity or true positive rate) quantifies the proportion of areas (1s increments along transect) of S. fragilissima in the transect correctly identified. It varies between 0 and 1, were 1 means all areas are identified.
   * $ Recall=  {TP/(TP+FN)} $

- Precision (positive predictive value) quantifies the proportion of TPs among all the positive predictions for areas of S. fragilissima. A value of 1 indicates all the positive detections for areas of S. fragilissima are in fact areas of S. fragilissima.
  * $ Precision=  {TP/(TP+FP)} $ 

- Accuracy quantifies the number of all correct predictions (TP + TN) for areas of S. fragilissima presence or absence with respect to the total predictions made. A value of 1 implies no false predictions (FP + FN) and all correct predictions are identified.  
        *Accuracy=  (TP+TN)/(TP+FP+TN+FN)  .   (9)

- F1 Score quantifies the harmonic mean of precision and recall, meaning a value of 1 indicates perfect precision and recall (as defined in equation 7 and 8). 
        *F_1=  TP/(TP+1/2(FP+FN))=2∙(precision∙recall)/(precision+recall).   (10)

- Root mean square error: Assessing error of the best classifier at counting individual S. fragilissima
        *RMSE= √MSE  = √(1/N ∑_{(i=1)}^N▒〖(y_i-(y_i ) ̂ 〗) )^2,    (11)
Where, N is the amount of data points (N = 100), i is the data point number being compared (1 – 100th), y_i is the count of S. fragilissima at the ith data point that is manually counted, whilst (${y_i}) ̂ is the corresponding predicted count made by the classifier. 


