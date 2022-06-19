#!/bin/bash

echo "Installing vim"
git clone --depth 1 https://github.com/vim/vim.git ~/vim
pushd ~/vim

# Configure features
./configure --with-features=huge --with-x=yes --disable-gui

# Compile
make

# Install
sudo make install

# Cleanup
make clean
make distclean
popd
