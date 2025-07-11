#!/bin/bash

source .venv/bin/activate

echo "Setting up IREE tools environment"
export PATH="$(pwd)/iree-install/bin:$PATH"

echo "Setting up IREE Python Bindings environment"
source iree-build/.env && export PYTHONPATH