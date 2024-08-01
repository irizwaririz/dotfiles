#!/bin/bash

echo "Installing slock"
git clone --depth 1 https://git.suckless.org/slock ~/slock
pushd ~/slock

# Build and install
sudo make clean install

popd
