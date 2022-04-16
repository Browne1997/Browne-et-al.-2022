# Codes used in support of publication: Browne et al 2022

Author: Erin Browne and David Hutchinson 

Customised codes for data preparation:
  1. 

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
