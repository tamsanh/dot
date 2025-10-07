#!/bin/bash

CURR_DIR=$(
	cd $(dirname $0)
	pwd
)
ROOT_DIR=$(
	cd ${CURR_DIR}
	git rev-parse --show-toplevel
)

cd ${ROOT_DIR}

set -x

# Backup the previous tmux.conf if one exists, but don't overwrite
# the previous backup if one exists
if [[ -e ${HOME}/.tmux.conf && ! -e ${HOME}/.tmux.conf.bak ]]; then
	mv ${HOME}/.tmux.conf{,.bak}
	echo Backed up ~/.tmux.conf
fi

# Setup tpm
if [[ ! -d ${HOME}/.tmux/plugins/tpm ]]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

function add_tmux_conf {
  rc=${HOME}/.tmux.conf
 
  if [[ ! -e ${rc} ]]; then
    touch ${rc}
  fi

	# Preserve original rc
	start_header=\#\ ======\ START\ tamsanh-dot\ ======
  end_header=\#\ ======\ END\ tamsanh-dot\ ======

	rc_head=$(mktemp)
	rc_tail=$(mktemp)

	# Find the before and after of the header
	fgrep "${start_header}" ${rc} >/dev/null
	if [ $? -ne 0 ]; then
		cat ${rc} >${rc_head}
	else
    start_loc=$(fgrep -n "${start_header}" ${rc} | cut -d: -f1)
    end_loc=$(fgrep -n "${end_header}" ${rc} | cut -d: -f1)
    line_count=$(wc -l < ${rc})
    head -n $((${start_loc}-1)) ${rc} >${rc_head}
    tail -n $((${line_count} - ${end_loc})) ${rc} >${rc_tail}
	fi

	# Add reference
	new_rc=$(mktemp)
	cat <(cat ${rc_head}) <(
		cat <<EOF
${start_header}

source-file ${ROOT_DIR}/tmux.conf

${end_header}
EOF) <(cat ${rc_tail}) > ${new_rc}

	# Overwrite the previous rc
  if [[ ! -e ${rc}.bak ]]; then
    cp ${rc}{,.bak}
  fi
  mv ${new_rc} ${rc}
}

add_tmux_conf

