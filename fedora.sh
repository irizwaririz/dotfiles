#!/bin/bash

# Update Fedora packages to the latest version
sudo dnf upgrade -y

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    sudo dnf install -y $1
  else
    echo "Already installed: ${1}"
  fi
}

# basic packages
install curl
install wget
install make
install gcc

# development
install git
install stow
install ripgrep
install tmux

# st dependencies
install pkg-config
install fontconfig-devel
install libX11-devel
install libXft-devel
install dejavu-sans-mono-fonts.noarch 

# slock dependencies
install libXrandr-devel

# vim dependencies
install ncurses-devel
install libXt-devel

# tmux dependencies
install xclip

# system management
install htop
install ncdu

## desktop programs
# multimedia
install feh
install sxiv
install mpv
install pulsemixer
install jmtpfs

# notification
install dunst

# keybindings
install xbindkeys

# Run all installation scripts in programs/
for f in programs/*.sh; do bash "$f" -H; done

# Symlink dotfiles
# ./dotfiles.sh fedora
