#!/bin/bash

CURR_DIR=$(
	cd $(dirname $0)
	pwd
)
cd ${CURR_DIR}

./shell.sh
./nvim.sh
