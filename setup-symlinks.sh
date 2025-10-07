#!/bin/bash

function uplink {
    local src=$1
    local trgt=$2

    full_trgt_path=`pwd`/${trgt}

    if [ ! -e "${trgt}" ]; then
        echo "Linking ${src} to ${full_trgt_path}"
        ln -s ${src} "${trgt}"
    else
        if [ -L "${trgt}" ]; then
            echo "Skipping ${full_trgt_path}"
        else
            echo "Exists and Not Symlinked: ${full_trgt_path}"
        fi
    fi

}

CURR_DIR=$(cd `dirname $0`; pwd)

cd ~
uplink $CURR_DIR/aerospace/aerospace.toml .aerospace.toml
uplink $CURR_DIR/vimrc .vimrc
uplink $CURR_DIR/gitconfig .gitconfig
uplink $CURR_DIR/vscode/keybindings.json "Library/Application Support/Code/User/keybindings.json"

mkdir -p .config
cd .config

if [ ! -e ghostty ]; then
    ln -s $CURR_DIR/ghostty ghostty
fi

