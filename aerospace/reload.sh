#!/bin/bash

CUR_DIR=$(cd `dirname $(readlink -f $0)`; pwd)


# Check the number of connected monitors
monitor_count=$(aerospace list-monitors | wc -l)

monitor_files=(
    "NEVER"
    "single-screen.toml"
    "dual-screen.toml"
    "triple-screen.toml"
)

out_file=$CUR_DIR/temp.aerospace.toml
target_screen_file=${monitor_files[${monitor_count}]}

cat $CUR_DIR/aerospace.base.toml $CUR_DIR/${target_screen_file} > $CUR_DIR/temp.aerospace.toml

# Reload aerospace to apply the new configuration
aerospace reload-config

