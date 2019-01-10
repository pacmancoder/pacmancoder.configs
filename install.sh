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

DISTRO="unknown"

function detect_distro
{
    display_topic "==== Detecting distro ===="
    DIST_INFO=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    if [[ $DIST_INFO == *"Solus"* ]]; then
        DISTRO="solus"
    elif [[ $DIST_INFO == *"Ubuntu"* ]]; then
        DISTRO="ubuntu"
    else
        echo "Cant'd detect distro"
        set -e
    fi
    display_success "Detected $DISTRO"
}

function install_package {
    display_topic "==== Installing package $1 ===="
    case $DISTRO in
        solus)
            sudo eopkg install -y "$1"
        ;;
        ubuntu)
            sudo apt -y install "$1"
        ;;
    esac
    display_success "Installed $1"
}

function install_dev_package {
    display_topic "==== Installing dev-package $1 ===="
    case $DISTRO in
        solus)
            sudo eopkg install -y "$1-devel"
        ;;
        ubuntu)
            sudo apt -y install "$1-dev"
        ;;
    esac
    display_success "Installed $1"
}

function install_build_essential {
    display_topic "==== Installing build essential ===="
    case $DISTRO in
        solus)
            sudo eopkg install sudo eopkg install -y -c system.devel
        ;;
        ubuntu)
            sudo apt -y install build-essential
        ;;
    esac
    display_success "Installed build-essential"
}

# =========== Detect Distro ==============
detect_distro

# ================== zsh =================
ask_app "zsh"
if [ -z $skip ]; then
    install_package "zsh"
    link_config "$CONFIG_STORAGE/zsh/zshrc" "$HOME/.zshrc"
    display_success "zsh installed"
fi

# ================ neovim ================
ask_app "neovim"
if [ -z $skip ]; then
    install_package "neovim"
    install_package "python3"
    install_dev_package "python3"
    install_package "cmake"
    install_build_essential
    curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    mkdir -p "$HOME/.config/nvim"
    link_config "$CONFIG_STORAGE/neovim/init.vim" "$HOME/.config/nvim/init.vim"
    sudo pip3 install nvim
    # Install plugins
    nvim -c "q"
    (
        cd "$HOME/.config/nvim/plugged/youcompleteme"
        python3 install.py --clang-completer
    )
    display_success "neovim installed"
fi

ask_app "tmux"
if [ -z $skip ]; then
    install_package "tmux"
    git clone https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
    link_config "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"
    link_config "$CONFIG_STORAGE/tmux/tmux.conf.local" "$HOME/.tmux.conf.local"
    display_success "tmux installed"
fi

display_success "Configuration finished!"
