#!/bin/bash

source .venv/bin/activate

echo "Setting up IREE tools environment"
export PATH="$(pwd)/iree-install/bin:$PATH"

echo "Setting up IREE Python Bindings environment"
source iree-build/.env && export PYTHONPATH

echo "Setting up Vitis"
export VITIS="/usr/xilinx/Vitis/2024.2"
export XILINXD_LICENSE_FILE="/usr/xilinx/License/AIE.lic"