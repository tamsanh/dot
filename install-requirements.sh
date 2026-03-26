#!/bin/bash

CUR_DIR=$(cd `dirname $0`; pwd)

function install_if_nonzero {
    local retcode=$1
    local toolname=$2
    local option=$3
    if [[ $retcode -ne 0 ]]; then
        echo -e "\tInstalling $toolname"
    if [[ ! -z $option ]]; then
        echo -e "\t\twith Option $option"
    fi
        brew install $option $toolname
    else
        echo -e "\tSkipping $toolname"
    fi
}

function maybe_install {
    local cmd=$1
    local toolname=${2:-${cmd}}
    local option=$3
    $cmd --help >/dev/null 2>&1
    install_if_nonzero $? $toolname $option
}

function must_install {
    local cmd=$1
    $cmd --help >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo -e "\tMust Install ${cmd}"
        exit 1
    fi
}

function setup_dot_python {
    echo "Setup Python"
    cd $CUR_DIR
    if [ ! -e .venv ]; then
        echo -e "\tCreating cirtualenv at ${CUR_DIR}/.venv"
        virtualenv .venv
    else
        echo -e "\tSkipping virtualenv at ${CUR_DIR}/.venv"
    fi

    source .venv/bin/activate

    # Pipe seperator between
    # IMPORT_NAME|INSTALL_NAME
    # because python packages sometimes
    # two different names between pip install
    # and python import

    python_pkgs=(
        "tomli_w|tomli_w"
    )
    for pkg in ${python_pkgs[@]}; do
        pkg_import=${pkg##*|}
        pkg_install=${pkg%%|*}

        # Install if import does not exist
        python -c "import ${pkg_import}" >/dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            echo -e "\tInstalling python ${pkg_install}"
            pip install ${pkg_install}
        else
            echo -e "\tSkipping python ${pkg_install}"
        fi

    done
}


echo "Start Installing dot requirements"
echo
echo "Setup command line tools"

must_install asdf
must_install python

# maybe_install aerospace "nikitabobko/tap/aerospace" --cask
# maybe_install ghostty
maybe_install autojump
maybe_install worktrunk
maybe_install xz
maybe_install starship
# maybe_install bat

# maybe_install delta git-delta

echo
setup_dot_python

echo
echo "Done Installing dot requirements"

if [[ ! -e $CUR_DIR/Lilex.zip ]]; then
    echo 'Downloading Lilex Font'
    curl -o $CUR_DIR/Lilex.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Lilex.zip
    open $CUR_DIR/Lilex.zip
    open $CUR_DIR/Lilex
else
    echo 'Skip Downloading Lilex Font'
fi


echo "Disable Key Repeat"

defaults write -g ApplePressAndHoldEnabled -bool false

