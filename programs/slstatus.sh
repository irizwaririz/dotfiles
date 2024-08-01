#!/bin/bash

echo "Installing slstatus"
git clone --depth 1 https://github.com/irizwaririz/slstatus ~/slstatus
pushd ~/slstatus

# Build and install
sudo make clean install

popd
