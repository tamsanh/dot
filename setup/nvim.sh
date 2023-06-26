#!/bin/bash

# Creates a symbolic link to the ./nvim folder that contains
# neovim settings.

CURR_DIR=$(
	cd $(dirname $0)
	pwd
)
ROOT_DIR=$(
	cd ${CURR_DIR}
	git rev-parse --show-toplevel
)

mkdir -p ${HOME}/.config

# If nvim already exists and nvim is not a symlink
if [[ -e ${HOME}/.config/nvim && ! -L ${HOME}/.config/nvim ]]; then
	mv ${HOME}/.config/nvim{,.bak}
fi

ln -s ${ROOT_DIR}/nvim ${HOME}/.config/nvim
