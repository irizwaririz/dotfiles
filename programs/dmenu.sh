#!/bin/bash

echo "Installing dmenu"
git clone --depth 1 https://git.suckless.org/dmenu ~/dmenu
pushd ~/dmenu

# Build and install
sudo make clean install

popd
