# VectorBlox SDK

VectorBlox is an SDK for compiling and running TFLITE INT8 networks on the VectorBlox accelerator.

The list of the TFLITE INT8 supported operators can be found [here](./docs/OPS.md) (currently 64 supported).

Networks must be converted via the included scripts.

The networks can then be run via the VectorBlox simulator, or on a physical VectorBlox accelerator.

## Prerequisites


 To use the VectorBlox SDK, you will need run the SDK in an Ubuntu 20.04, 22.04, or 24.04 environment with Python 3.10+.
> To check which version of python is on the native Ubuntu OS, type either `python -V` or `python3 -V`
 If using WSL, ensure you are running from your home directory or have permissions set.

## Downloading the SDK

There are two options for downloading the sdk:

 1) Download an archive (zip or tar.gz) from https://github.com/Microchip-Vectorblox/VectorBlox-SDK/releases
     
 2) Clone this repository
     
### Install required dependencies (requires sudo permission)

Navigate to the root directory of `VectorBlox-SDK` and run the following commands:

```
bash install_dependencies.sh
```

### Activate (and installs if needed) Python virtual environment, and sets necessary environment variables
```
source setup_vars.sh
```
If during `source setup_vars.sh` you get an error about "No module named 'mxnet'",
chances are git-lfs is not configured correctly.

## Run tutorials

Several tutorials are provided to generate CoreVectorBlox compatible Binary Large OBjects (BLOBs).

Tutorials will download the model file and convert it to .tflite if necessary.
Finally, it will be converted into a quantized Vectorblox BLOB with a .vnnx and .hex file extension.

Follow the below steps to run a tutorial.

```
cd $VBX_SDK/tutorials/{network_source}/{network}
bash {network}.sh
```

A list of tutorials can be found [here](./tutorials/README.md)
