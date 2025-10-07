#!/bin/bash


CUR_DIR=$(cd `dirname $(readlink -f $0)`; pwd)


MAX_MONITORS=`aerospace list-monitors | wc -l`

source $CUR_DIR/../.venv/bin/activate

python -c """
import tomllib
import tomli_w


max_monitors = $((${MAX_MONITORS}))

with open('${CUR_DIR}/temp.aerospace.toml', 'rb') as f:
    t = tomllib.load(f)

assignments = t['workspace-to-monitor-force-assignment']

new_assignments = {}
for space, assignment in assignments.items():
    # Skip space R to allow
    # overflow when plugging in
    # new multiple monitors
    if space == 'R':
        continue
    new_assignments[space] = (assignment % (max_monitors)) + 1

t['workspace-to-monitor-force-assignment'] = new_assignments

with open('${CUR_DIR}/temp.aerospace.toml', 'wb') as f:
    tomli_w.dump(t, f)

""" > ~/tempfile 2>&1

aerospace reload-config

