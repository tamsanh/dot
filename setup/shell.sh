#!/bin/bash

set -x

CURR_DIR=$(
	cd $(dirname $0)
	pwd
)
ROOT_DIR=$(
  cd ${CURR_DIR}
  git rev-parse --show-toplevel
)

cd ${ROOT_DIR}

function add_shellrc {
	rc=$1

	# Preserve original rc
	start_header=\#\ ======\ START\ tamsanh-dot\ ======
	stop_header=\#\ ======\ END\ tamsanh-dot\ ======

	rc_head=$(mktemp)
	rc_tail=$(mktemp)

	# Find the before and after of the header
	fgrep "${start_header}" ${rc} >/dev/null
	if [ $? -ne 0 ]; then
		cat ${rc} >${rc_head}
	else
		start_loc=$(awk '/'${start_header}'/ {print FNR}' ${rc})
		end_loc=$(awk '/'${stop_header}'/ {print FNR}' ${rc})
		remaining_count=$(wc -l ${rc})
		head -n ${start_dot} >${rc_head}
		tail -n $((${line_count} - ${end_dot})) >${rc_tail}
	fi

	# Add reference
	new_rc=$(mktemp)
	cat <(cat ${rc_head}) <(
		cat <<EOF
${start_header}

source ${ROOT_DIR}/shellrc

if [ ! -e ${ROOT_DIR}/last_check]; then
  date +%s > ${ROOT_DIR}/last_check
fi

last_check_time=\$(cat \${ROOT_DIR}/last_check)
curr_time=\$(date +%s)

time_since_last_check=\$((\$(curr_time)-\$(last_check_time)))
if [ \${time_since_last_check} -ge 86400 ]; then
  git -C ${ROOT_DIR} pull origin main > /dev/null
  date +%s > ${ROOT_DIR}/last_check
fi

${stop_header}
EOF) <(cat ${rc_tail}) > ${new_rc}

	# Overwrite the previous rc
  cp ${rc}{,.bak}
  mv ${new_rc} ${rc}
}

# Adds to .bashrc
if [ -e ${HOME}/.bashrc ]; then
  add_shellrc ${HOME}/.bashrc
fi

# Adds to .zprofile
if [ -e ${HOME}/.zprofile ]; then
  add_shellrc ${HOME}/.zprofile
fi
