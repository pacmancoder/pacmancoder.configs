#!/bin/bash

# check root access
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

HOME=$(eval echo "~$SUDO_USER")

USE_SYMLINK=true
CONFIG_STORAGE="$HOME/core/configs"

function link_config {
    [ -e $2 ] && mv "$2" "$2.bak"
    if [ "$USE_SYMLINK" == true ]; then
          ln -s $1 $2
    else
          ln $1 $2
    fi
}

link_config "$CONFIG_STORAGE/zshrc" "$HOME/.zshrc"
link_config "$CONFIG_STORAGE/zshrc" "$HOME/.zshrc-root"

