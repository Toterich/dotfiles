#!/bin/sh

# Prerequisites
#
# 1. Clone this repository
# git clone --bare <git-repo-url> $HOME/.cfg
#
# 2. Source this script
# source ./.setup.sh

config() {
    /usr/bin/git --git-dir="$HOME"/.cfg/ --work-tree="$HOME" "$@"
}

# Backup local config files
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}

# Checkout config
config checkout

# Source config files
if [ "$(ps -p $$ -ocomm=)" == "bash" ];
then
    . "$HOME"/.bashrc
fi

# Install Vundle
if [ -x "$(command -v nvim)" ] || [ -x "$(command -v vim)" ];
then
    git clone https://github.com/VundleVim/Vundle.vim.git "$HOME"/.vim/bundle/Vundle.vim
fi
