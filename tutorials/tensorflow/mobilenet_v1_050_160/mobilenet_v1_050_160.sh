
##########################################################
#  _    __          __             ____  __              #
# | |  / /__  _____/ /_____  _____/ __ )/ /___  _  __    #
# | | / / _ \/ ___/ __/ __ \/ ___/ __  / / __ \| |/_/    #
# | |/ /  __/ /__/ /_/ /_/ / /  / /_/ / / /_/ />  <      #
# |___/\___/\___/\__/\____/_/  /_____/_/\____/_/|_|      #
#                                                        #
# https://github.com/Microchip-Vectorblox/VectorBlox-SDK #
# v2.0                                                   #
#                                                        #
##########################################################

set -e
echo "Checking and activating VBX Python Environment..."
if [ -z $VBX_SDK ]; then
    echo "\$VBX_SDK not set. Please run 'source setup_vars.sh' from the SDK's root folder" && exit 1
fi
source $VBX_SDK/vbx_env/bin/activate

echo "Checking for Numpy calibration data file..."
if [ ! -f $VBX_SDK/tutorials/imagenetv2_rgb_20x160x160x3.npy ]; then
    wget -P $VBX_SDK/tutorials/ https://vector-blox-model-zoo.s3.us-west-2.amazonaws.com/EAP/calib_npy/imagenetv2_rgb_20x160x160x3.npy
fi

echo "Downloading mobilenet_v1_050_160..."
# model details @ https://tfhub.dev/google/imagenet/mobilenet_v1_050_160/classification/5
wget https://tfhub.dev/google/imagenet/mobilenet_v1_050_160/classification/5?tf-hub-format=compressed -O mobilenet_v1_050_160.tar.gz
mkdir -p mobilenet_v1_050_160
tar -xzf mobilenet_v1_050_160.tar.gz -C mobilenet_v1_050_160
python ../../saved_model_signature.py mobilenet_v1_050_160

echo "Generating TF Lite..."
tflite_quantize mobilenet_v1_050_160 mobilenet_v1_050_160.tflite -d $VBX_SDK/tutorials/imagenetv2_rgb_20x160x160x3.npy \
--scale 255. --shape 1 160 160 3

if [ -f mobilenet_v1_050_160.tflite ]; then
   tflite_preprocess mobilenet_v1_050_160.tflite  --scale 255
fi

if [ -f mobilenet_v1_050_160.pre.tflite ]; then
    echo "Generating VNNX for V1000 configuration..."
    vnnx_compile -c V1000 -t mobilenet_v1_050_160.pre.tflite -o mobilenet_v1_050_160.vnnx
fi

if [ -f mobilenet_v1_050_160.vnnx ]; then
    echo "Running Simulation..."
    python $VBX_SDK/example/python/classifier.py mobilenet_v1_050_160.vnnx $VBX_SDK/tutorials/test_images/oreo.jpg 
fi

deactivate