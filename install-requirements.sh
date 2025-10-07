#!/bin/bash

CUR_DIR=$(cd `dirname $0`; pwd)

brew install aerospace
brew install ghostty
brew install git-delta
brew install starship


cd $CUR_DIR
if [ ! -e .venv ]; then
    virtualenv .venv
    source .venv/bin/activate
    pip install tomli_w
fi

