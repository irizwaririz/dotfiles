#!/bin/bash

echo "Installing jmtpfs"
git clone --depth 1 https://github.com/JasonFerrara/jmtpfs ~/slstatus
pushd ~/jmtpfs

# Build and install
sudo make clean install

popd
