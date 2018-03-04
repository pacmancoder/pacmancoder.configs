#!/bin/bash

USE_SYMLINK=true
CONFIG_STORAGE="$HOME/core/configs"

function display_topic {
    echo "$(tput bold)$1$(tput sgr0)"
}

function display_warn {
    echo "$(tput setaf 3)$1$(tput sgr0)"
}

function display_error {
    echo "$(tput setaf 1)$1$(tput sgr0)"
}

function display_success {
    echo "$(tput setaf 2)$1$(tput sgr0)"
}


function link_config {
    [ -e $2 ] && mv "$2" "$2.bak"
    if [ "$USE_SYMLINK" == true ]; then
        ln -s $1 $2
    else
        ln $1 $2
    fi
}

function ask_app {
    display_topic "==== $1 ===="
    echo "Do you want to set configs for $1? (y/n)"
    local userInput
    read userInput
    if [ "$userInput" == "y" ]; then
        skip=""
        echo "Installing $1 configs..."
    else
        skip="true"
        echo "Skipping $1 configs..."
    fi
}

# ================== zsh =================
ask_app "zsh"
if [ -z $skip ]; then
    link_config "$CONFIG_STORAGE/zsh/zshrc" "$HOME/.zshrc"
fi

# ================ neovim ================
ask_app "neovim"
if [ -z $skip ]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    mkdir -p "$HOME/.config/nvim"
    link_config "$CONFIG_STORAGE/neovim/init.vim" "$HOME/.config/nvim/init.vim"
    display_warn "Don't forget to run :PlugInstall and UpdateRemotePlugins!"
fi

ask_app "tmux"
if [ -z $skip ]; then
    link_config "$CONFIG_STORAGE/tmux/tmux.conf.local" "$HOME/.tmux.conf.local"
    display_warn "Don't forget to install oh-my-tmux"
fi
