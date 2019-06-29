#!/bin/sh

sudo apt update  
sudo apt -y upgrade build-essential cmake pkg-config libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libgtk2.0-dev libgtk-3-dev libcanberra-gtk* libatlas-base-dev gfortran python2.7-dev python3-dev 
sudo apt -y install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
pip install numpy
pip3 install numpy

wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.5.zip
unzip opencv.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.4.5.zip
unzip opencv_contrib.zip

cd opencv-3.4.5/
rm -rf build
mkdir build
cd build

export CFLAGS="-mcpu=cortex-a53 -mfloat-abi=hard -mfpu=neon-fp-armv8 -mneon-for-64bits"
export CXXFLAGS="-mcpu=cortex-a53 -mfloat-abi=hard -mfpu=neon-fp-armv8 -mneon-for-64bits"

cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-3.4.5/modules \
-D ENABLE_NEON=ON \
-D ENABLE_VFPV3=ON \
-D BUILD_TESTS=OFF \
-D OPENCV_ENABLE_NONFREE=ON \
-D EXTRA_C_FLAGS=-mcpu=cortex-a53 -mfloat-abi=hard -mfpu=neon-fp-armv8 -mneon-for-64bits \
-D EXTRA_CXX_FLAGS=-mcpu=cortex-a53 -mfloat-abi=hard -mfpu=neon-fp-armv8 -mneon-for-64bits \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D WITH_GSTREAMER=ON \
-D BUILD_EXAMPLES=OFF ..


sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1024/' dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start

make -j4

sudo make install
sudo ldconfig

sed -i 's/CONF_SWAPSIZE=1024/CONF_SWAPSIZE=100/' dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start

python3 check.py

echo Done.
