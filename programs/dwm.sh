#!/bin/bash

echo "Installing dwm"
git clone --depth 1 https://github.com/irizwaririz/dwm ~/dwm
pushd ~/dwm

# Build and install
sudo make clean install

popd
