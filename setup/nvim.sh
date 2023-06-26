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

# Move the old nvim if it exists and isn't a symlink
if [[ -e ${HOME}/.config/nvim && ! -L ${HOME}/.config/nvim ]]; then
	mv ${HOME}/.config/nvim{,.bak}
fi

# Ignore symlink creation if nvim already is symlinked
if [[ ! -e ${HOME}/.config/nvim && -L ${HOME}/.config/nvim ]]; then {
  ln -s ${ROOT_DIR}/nvim ${HOME}/.config/nvim
}
