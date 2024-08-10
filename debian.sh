#!/bin/bash

# Update Ubuntu and get standard repository programs
sudo apt update && sudo apt full-upgrade -y

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    sudo apt install -y $1
  else
    echo "Already installed: ${1}"
  fi
}

# basic packages
install curl
install wget
install make
install gcc
install zip
install unzip

# development
install git
install stow
install ripgrep
install tmux

# st dependencies
install libxft-dev

# slock dependencies
install libxrandr-dev

# vim dependencies
install libncurses5-dev
install libxt-dev

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

# Get all upgrades
sudo apt upgrade -y
sudo apt autoremove -y

# Symlink dotfiles
# ./dotfiles.sh ubuntu
