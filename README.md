# Guidance and code used in publication Browne et al 2022

Author: Erin Browne and David Hutchinson 

Folders in repository correspond and include the following steps taken below

# Instructions and codes used in Methods: Training data preparation

![image](https://user-images.githubusercontent.com/91316035/167623090-17f7b6c2-183b-4633-b18b-962659cc5054.png)
Figure 1| Training data preparation 

1. extract_frames_N.py: code to produce deinterlaced framegrabs at 20 secs or 1min intervals from ROV Isis video (see Fig.1A) + * Code required to run the ffmpeg section * - DAVID
2. xls2csv.py: code to transform BIIGLE annotation .xls files to VIAME .csv format (see Fig.1B)
3. Installation instruction for VIAME 
   * 3i. Instructions (+ file structure) to run the pre-processing of the raw framegrabs for data augmentation
5. skip_viame.py: code to produce same data outputs needed for training as VIAME without the augmentation of brightness and resolution variance (see Fig1.C)

# Instructions and codes used in Methods: Training classifiers and Assessment of classifier training performance
1. Instructions to compile Darknet deep learning framework to user local machine for 1) training and 2) Real-time running
2. File structure for training on local machine should be as follows:
# FIGURE OF THIS ERIN 
3. Weights and configuration files explanation and source:
This documents where the ‘off-the-shelf’ classifier architectures weights files (used for storing the parameters learnt during training) and corresponding configuration files are sourced. These weights are either pre-trained on larger imagery datasets (lower level features already learned and stored in weights file), also known as transfer learning. Or the weights have no pre-trained features, therefore all features learned and stored in the weights files are directly from the training imagery created in this study. 

S2 Table 1| Sources for weights (where learnt parameters are stored corresponding to features of the target class) and configuration files (outlining classifiers architecture in terms of functions, mathematics etc.) for training from scratch (VIAME API GitHub Version 0.15.1 (YOLOv3) and Version 0.17.2 (YOLOv4) and transfer learning (AlexeyAB GitHub).

| Classifiers  | Weights files      | Configuration files |
| -------------| ------------------ | ------------------- |
|              | Scratch | Transfer | Scratch | Transfer  |
| YOLOv3       | https://pjreddie.com/media/files/yolov3-spp.weights and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_v3_seed.weights | https://raw.githubusercontent.com/AlexeyAB/darknet/master/cfg/yolov3-spp.cfg and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_train.cfg |
| YOLOv4       | https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137 and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_seed.weights  |  https://raw.githubusercontent.com/AlexeyAB/darknet/master/cfg/yolov4.cfg and https://github.com/VIAME/VIAME/tree/main/configs/pipelines/models/yolo_train.cfg |






Real-time codes:
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
