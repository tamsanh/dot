#!/bin/bash

set -e

CUR_DIR=$(cd `dirname $0`; pwd)

MAX_MONITORS=`aerospace list-monitors | wc -l`

python3 -c """
import tomllib
import tomli_w


max_monitors = $((${MAX_MONITORS}))

with open('${CUR_DIR}/temp.aerospace.toml', 'rb') as f:
    t = tomllib.load(f)

assignments = t['workspace-to-monitor-force-assignment']

new_assignments = {}
for space, assignment in assignments.items():
    new_assignments[space] = (assignment % (max_monitors)) + 1

t['workspace-to-monitor-force-assignment'] = new_assignments

with open('${CUR_DIR}/temp.aerospace.toml', 'wb') as f:
    tomli_w.dump(t, f)

"""

aerospace reload-config

