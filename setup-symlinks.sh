#!/bin/bash

CUR_DIR=$(cd `dirname $0`; pwd)

function uplink {
    local src=$1
    local trgt=$2

    full_trgt_path=`pwd`/${trgt}

    if [ ! -e "${src}" ]; then
        echo "Error: Missing ${src}"
        return
    fi

    if [ ! -e "${trgt}" ]; then
        echo "Linking ${src} to '${full_trgt_path}'"
        ln -s ${src} "${trgt}"
    else
        if [ -L "${trgt}" ]; then
            echo "Skipping '${full_trgt_path}'"
        else
            echo "Exists and Not Symlinked: '${full_trgt_path}'"
        fi
    fi

}

function setup_git {
    echo "Setup .gitconfig"
    uplink $CUR_DIR/git/gitconfig .gitconfig

    # git needs a special private file
    if [ ! -e .gitconfig-private ]; then
        cp $CUR_DIR/git/gitconfig-private .gitconfig-private
    fi
}

function setup_envvars {
    echo "Setup envvars:"
    echo "  DOT_DIR=\"${CUR_DIR}\""
    echo "export DOT_DIR=\"${CUR_DIR}\"" > ~/.zdotdir
}

cd ~

setup_git
setup_envvars

# Setup Aerospace
uplink $CUR_DIR/aerospace/rotate.sh .aerospace.rotate.sh
uplink $CUR_DIR/aerospace/reload.sh .aerospace.reload.sh

$CUR_DIR/aerospace/reload.sh
uplink $CUR_DIR/aerospace/temp.aerospace.toml .aerospace.toml

# Setup Vim
uplink $CUR_DIR/vimrc .vimrc

# Setup VSCode
uplink $CUR_DIR/vscode/keybindings.json "Library/Application Support/Code/User/keybindings.json"
uplink $CUR_DIR/vscode/settings.json "Library/Application Support/Code/User/settings.json"

# Setup Windsurf
uplink $CUR_DIR/vscode/keybindings.json "Library/Application Support/Windsurf/User/keybindings.json"
uplink $CUR_DIR/vscode/settings.json "Library/Application Support/Windsurf/User/settings.json"

# Setup Shell
uplink $CUR_DIR/shellrc .`basename ${SHELL}`rc

mkdir -p .config
cd .config

uplink $CUR_DIR/ghostty ghostty
uplink $CUR_DIR/starship/starship.toml starship.toml

