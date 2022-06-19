#!/bin/bash

echo "Installing nvm"
# Install nvm in order to install Node
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"

source ~/.bashrc

echo "Installing node"
# Install latest version of Node (used by coc.nvim)
nvm install --lts node
