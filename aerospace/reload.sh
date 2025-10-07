#!/bin/bash

set -x

CUR_DIR=$(cd `dirname $0`; pwd)


# Check the number of connected monitors
monitor_count=$(aerospace list-monitors | wc -l)

monitor_files=(
    "never.toml"
    "single-screen.toml"
    "dual-screen.toml"
    "triple-screen.toml"
)

out_file=$CUR_DIR/temp.aerospace.toml

cat $CUR_DIR/aerospace.base.toml $CUR_DIR/${monitor_files[${monitor_count}]} > $CUR_DIR/temp.aerospace.toml

# Reload aerospace to apply the new configuration
aerospace reload-config

