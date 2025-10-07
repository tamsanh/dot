#!/bin/bash

CURR_DIR=$(cd `dirname $0`; pwd)

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
    echo "Setup .gitconfig"
    uplink $CURR_DIR/git/gitconfig .gitconfig

    # git needs a special private file
    if [ ! -e .gitconfig-private ]; then
        cp $CURR_DIR/git/gitconfig-private .gitconfig-private
    fi
}

function setup_envvars {
    echo "Setup envvars:"
    echo "  DOT_DIR=\"${CURR_DIR}\""
    echo "export DOT_DIR=\"${CURR_DIR}\"" > ~/.zdotdir
}

cd ~

setup_git
setup_envvars

uplink $CURR_DIR/aerospace/temp.aerospace.toml .aerospace.toml
uplink $CURR_DIR/vimrc .vimrc
uplink $CURR_DIR/vscode/keybindings.json "Library/Application Support/Code/User/keybindings.json"

uplink $CURR_DIR/shellrc .`basename ${SHELL}`rc


mkdir -p .config
cd .config

uplink $CURR_DIR/ghostty ghostty
uplink $CURR_DIR/starship/starship.toml starship.toml

