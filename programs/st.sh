#!/bin/bash

echo "Installing st"
git clone --depth 1 https://github.com/irizwaririz/st ~/st
pushd ~/st

# Build and install
sudo make clean install

popd
