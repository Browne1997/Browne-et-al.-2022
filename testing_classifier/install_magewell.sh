# Download and Install software for Magewell Capture card using bash terminal window
# Download from https://magewell.com/products/pro-capture-hdmi#detail_driver
# cd to downloads and unpack software
tar -xvf ProCaptureForLinux_4236.tar.gz
pushd ProCaptureForLinux_4236
sudo bash install.sh
popd 
mwcap-info -l
