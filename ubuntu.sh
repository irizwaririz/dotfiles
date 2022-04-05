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

# development
install git
install stow
install ripgrep
install tmux

# vim dependencies
install libncurses5-dev
install libxt-dev

# system management
install htop
install ncdu

# Run all installation scripts in programs/
for f in programs/*.sh; do bash "$f" -H; done

# Get all upgrades
sudo apt upgrade -y
sudo apt autoremove -y

# Symlink dotfiles
# ./dotfiles.sh ubuntu
