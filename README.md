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

1. darknet_compiling: Instructions to compile Darknet on local machine for 1) training and 2) Real-time running
2. File structure for training on local machine outlined in XXXXX
3. Weights and configuration files explanation and source

Table 1| Sources for weights and configuration files for training from scratch (VIAME API GitHub Version 0.15.1 (YOLOv3) and Version 0.17.2 (YOLOv4)) and transfer learning (AlexeyAB GitHub).
| Classifiers  | Weights files      | Configuration files |
| ------------ | ------------------ | ------------------- |
| YOLOv3       | https://pjreddie.com/media/files/yolov3-spp.weights and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_v3_seed.weights | https://raw.githubusercontent.com/AlexeyAB/darknet/master/cfg/yolov3-spp.cfg and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_train.cfg |
| YOLOv4       | https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137 and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_seed.weights  |  https://raw.githubusercontent.com/AlexeyAB/darknet/master/cfg/yolov4.cfg and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_train.cfg |

4. set_training: using the outlined file structure (2.2) with the produce training image datasets (1.3 and 1.5) and sourced weights and configuration files this code will instruct how to run the training process on the users local machine (source code comes from: https://github.com/AlexeyAB/darknet)

# 3. Instructions and codes used in Methods: Testing classifier performance using independent data as part of a novel pipeline for real-time ROV deployment: in-situ and synthetic ship
![image](https://user-images.githubusercontent.com/91316035/163668237-5125358e-afaa-41f5-8f13-0a74f53569f1.png)
Figure 1| In-situ set-up for real-time or synthetic ship to test real-time ability or to perform post-analysis on video data for faster results.

The following equiptment is required:
  1. Magewell capture card inserted into computer
  2. HDMI cable tethering from ROV topside to magewell capture card (may require HDMI splitter)
  3. Computer (minimum requirements for 25FPS detecting -12GPU VRAM)
  4. Screen/Monitor
  
 The following installations required and codes to do so are outlined in testing_classifier 
  1. Magewell capture card software: install_magewell.sh
  2. FFMPEG for decoding and deinterlacing: install_ffmpeg.sh
  3. RTSP for sending data from Magewell to endpoint (darknet detector demo): install_rtsp.sh
 
 The following annotated codes outline how to run classifier over livestream or video
  1. run_capture.sh
  2. run_classifier.sh
  3. Transform .JSON generated detections (darknet detector demo) into a readable .csv format for classifier performance analysis (4.): save_data.py

Data outputs are individually saved frame from the darknet detector, denoting the object detected within the image is done with a bounding box and a confidence score. Additionally a .csv file is produce with every detection made and at which time within the video and frame number.

# 4. Computer vision metrics used in Methods: Calculating classifier performance in detecting areas of presence-absence and individual counts S. fragilissima

- Recall (sensitivity or true positive rate) quantifies the proportion of areas (1s increments along transect) of S. fragilissima in the transect correctly identified. It varies between 0 and 1, were 1 means all areas are identified.
   * $ Recall=  {TP/(TP+FN)} $

- Precision (positive predictive value) quantifies the proportion of TPs among all the positive predictions for areas of S. fragilissima. A value of 1 indicates all the positive detections for areas of S. fragilissima are in fact areas of S. fragilissima.
  * $ Precision=  {TP/(TP+FP)} $ 

- Accuracy quantifies the number of all correct predictions (TP + TN) for areas of S. fragilissima presence or absence with respect to the total predictions made. A value of 1 implies no false predictions (FP + FN) and all correct predictions are identified.  
  * $ Accuracy=  {(TP+TN)/(TP+FP+TN+FN)}

- F1 Score quantifies the harmonic mean of precision and recall, meaning a value of 1 indicates perfect precision and recall (as defined in equation 7 and 8). 
  * $ F_1=  {TP/(TP+1/2(FP+FN))=2∙(precision∙recall)/(precision+recall)} $ 

- Root mean square error: Assessing error of the best classifier at counting individual S. fragilissima
  * $ RMSE= {√MSE}  = {√(1/N ∑_{(i=1)}^N〖(y_i-(y_i ) ̂ 〗) )^2} $ 
Where, N is the amount of data points (N = 100), i is the data point number being compared (1 – 100th), y_i is the count of S. fragilissima at the ith data point that is manually counted, whilst (${y_i}) ̂ is the corresponding predicted count made by the classifier. 


