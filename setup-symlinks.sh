#!/bin/bash

function uplink {
    local src=$1
    local trgt=$2

    full_trgt_path=`pwd`/${trgt}

    if [ ! -e "${src}" ]; then
        echo "Error: Missing ${src}"
        return
    fi

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

function setup_git {
    uplink $CURR_DIR/git/gitconfig .gitconfig

    # git needs a special private file
    if [ ! -e .gitconfig-private ]; then
        cp $CURR_DIR/git/gitconfig-private .gitconfig-private
    fi
}


CURR_DIR=$(cd `dirname $0`; pwd)

cd ~

setup_git
uplink $CURR_DIR/aerospace/aerospace.toml .aerospace.toml
uplink $CURR_DIR/vimrc .vimrc
uplink $CURR_DIR/vscode/keybindings.json "Library/Application Support/Code/User/keybindings.json"

uplink $CURR_DIR/shellrc .`basename ${SHELL}`rc

mkdir -p .config
cd .config

if [ ! -e ghostty ]; then
    ln -s $CURR_DIR/ghostty ghostty
fi

