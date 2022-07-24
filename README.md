# Guidance and code used in publication Browne et al 2022

Author: Erin Browne and David Hutchinson 

Folders in repository correspond and include the following steps taken below

# 1. Instructions and codes used in Methods: training_data_preparation

![method_pipeline_v3](https://user-images.githubusercontent.com/91316035/180641159-98433eab-a921-4bfa-ac79-843a71d16f5e.jpg)
Figure 1| Training data preparation 

1. extract_frames_N.py: code to produce deinterlaced framegrabs at 20 secs or 1min intervals from ROV Isis video (see Fig.1A) + * Code required to run the ffmpeg section * - DAVID
2. xls2csv.py: code to transform BIIGLE annotation .xls files to VIAME .csv format (see Fig.1B)
3. viame_installation: Installation instructions for VIAME at https://github.com/VIAME/VIAME 
4. 1st training image dataset (VIAME_preprocessing.sh): with VIAME installed on local machine follow instructions in code to produce the augmented dataset (Fig1.C)
5. 2nd training image dataset (skip_viame.py): code to produce same data outputs needed for training as VIAME without augmentation (varying brightness and resolution) (Fig1.C)

# 2. Instructions and codes used in Methods: training_classifier

1. darknet_compiling: Instructions to compile Darknet on local machine for 1) training and 2) Real-time running
2. File structure for training on local machine outlined in 

![training_filestruct](https://user-images.githubusercontent.com/91316035/180641405-492942e4-374d-4e70-8ea0-8e0269380be2.jpg)
Figure 2: File structure on local machine required for training

3. Weights and configuration source (Table 1) 

Table 1| Sources for weights and configuration files for training from scratch (VIAME API GitHub Version 0.15.1 (YOLOv3) and Version 0.17.2 (YOLOv4)) and transfer learning (AlexeyAB GitHub).
| Classifiers  | Weights files      | Configuration files |
| ------------ | ------------------ | ------------------- |
| YOLOv3       | https://pjreddie.com/media/files/yolov3-spp.weights and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_v3_seed.weights | https://raw.githubusercontent.com/AlexeyAB/darknet/master/cfg/yolov3-spp.cfg and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_train.cfg |
| YOLOv4       | https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137 and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_seed.weights  |  https://raw.githubusercontent.com/AlexeyAB/darknet/master/cfg/yolov4.cfg and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_train.cfg |

4. train_classifier: using the outlined file structure (diagram 2.2), two training image datasets (1.3 and 1.5), sourced weights and configuration files (2.3) this code will instruct how to run the training process on the users local machine (source code comes from: https://github.com/AlexeyAB/darknet).


ADD/COMPORATE 
This documents where the ‘off-the-shelf’ classifier architectures weights files (used for storing the parameters learnt during training) and corresponding configuration files are sourced. These weights are either pre-trained on larger imagery datasets (lower level features already learned and stored in weights file), also known as transfer learning. Or the weights have no pre-trained features, therefore all features learned and stored in the weights files are directly from the training imagery created in this study. 

5. Calculation of mean Average Precision (mAP) outputted by Darknet detector demo explained in detail: 

The following performance metrics are used to calculate mAP:
True positives (TP): the number of correct detections of a ground-truth bounding box; 
False positives (FP): the number of incorrect detections of a non-existent object or a detection misplaced from the ground-truth bounding boxes;
False negative (FN): the number of undetected ground-truth bounding boxes;
In order to define what a correct detection is the Intersection over Union (IoU) metric is used. IoU measures the overlapping area between the predicted bounding box (B_p) and the ground-truth bounding box (B_gt) from the training dataset, and divided by the area of union between them. It can be defined using the following equation (Padilla et al., 2020),  
IoU=  area(B_p∩B_gt )/(area(B_p∪B_gt ).    (1)
The IoU has an associated threshold (t) that is pre-defined by the user, thus a correct detection can be classified as IoU ≥t and incorrect if IoU <t. In this case IoU was set to 0.5; meaning 50% overlap between B_p and B_gt is required for a detection to be counted as a TP. 
From the number of TP, FP, FN detections made by the classifiers precision P and recall R are calculated respectively and defined as
P=  TP/(TP+FP),     (2)
R=  TP/(TP+FN).     (3)
Precision is the percentage of TPs within all the predictions (i.e. rate of FPs), where IoU threshold is 0.5. Whilst recall is the percentage of TPs amongst all the given ground truths. During each training cycle the classifiers precision and recall values are plotted on a P-R curve, were the area under the P-R curve (AUC) indicates the classifiers performance, a good performance would be indicative of a high precision with increasing recall. To increase the accuracy of AUC the curve is interpolated using an 11-pointed average precision (AP, Everingham et al., 2010) defined as:
AP=  1/11 ∑_(R∈{0,0.1,….1})▒〖P_interp (R)〗,(4)
Where,
P_interp (R)=max⁡〖P(R ̃),〗  R ̃≥R.   (5)
Here the maximum precision P_interp (R) at 11 equally spaced recall levels [0,0.1,...,1] is averaged. Then mAP is calculated to give a measure of an object detectors performance given multiple classes are represented in the training dataset. Thus, it can be defined as: 
mAP=  1/N ∑_(i=1)^N▒〖AP_i 〗,(6)
Where the AP_i is simply the AP at each 11 point interval (i) on the P-R curve over all classes (N) (Padilla et al., 2020). In this study N =1 making mAP≈AP.



# 3. Instructions and codes used in Methods: testing_classifier
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
  1. Compresses and deinterlaces livestream, and then passes this from input device (Magewell Capture Card) and send to endpoint device (Darknet detector demo) run_capture.sh
  2. Feeds livestream to darknet detector demo for real time classification and detection: run_classifier.sh
  3. Transform .JSON generated detections (darknet detector demo) into a readable .csv format for classifier performance analysis (4.): save_data.py

# 4. Codes used in Methods for classifier performance in real-time: classifier_performance

Calculations and codes used for classifier performance in detecting areas of presence-absence and individual counts S. fragilissima

Code: presence_absence.R
- Recall (sensitivity or true positive rate) quantifies the proportion of areas (1s increments along transect) of S. fragilissima in the transect correctly identified. It varies between 0 and 1, were 1 means all areas are identified.
   * $ Recall=  {TP/(TP+FN)} $

- Precision (positive predictive value) quantifies the proportion of TPs among all the positive predictions for areas of S. fragilissima. A value of 1 indicates all the positive detections for areas of S. fragilissima are in fact areas of S. fragilissima.
  * $ Precision=  {TP/(TP+FP)} $ 

- Accuracy quantifies the number of all correct predictions (TP + TN) for areas of S. fragilissima presence or absence with respect to the total predictions made. A value of 1 implies no false predictions (FP + FN) and all correct predictions are identified.  
  * $ Accuracy=  {(TP+TN)/(TP+FP+TN+FN)}

- F1 Score quantifies the harmonic mean of precision and recall, meaning a value of 1 indicates perfect precision and recall (as defined in equation 7 and 8). 
  * $ F_1=  {TP/(TP+1/2(FP+FN))=2∙(precision∙recall)/(precision+recall)} $ 

Code: abundance.R
- Root mean square error: Assessing error of the best classifier at counting individual S. fragilissima
  * $ RMSE= {√MSE}  = {√(1/N ∑_{(i=1)}^N〖(y_i-(y_i ) ̂ 〗) )^2} $ 

Where, N is the number of 1-second increments (N = 100), i is the increment number being compared (1 – 100th), y_i is the manual count of S. fragilissima at the ith data point, whilst (${y_i}$) ̂ is the corresponding predicted count made by the classifier. 


