#!/bin/bash

LOG_DIR="$(realpath "$1")"
SAMPLE="$2"

mkdir -p "$LOG_DIR"

# Go to SALT repo and source environment
cd /afs/cern.ch/user/c/ceimthur/salt || exit 1
set --
source setup.sh

# Go to dumper-to-salt repo and run conversion
cd /afs/cern.ch/user/c/ceimthur/dumper-to-salt || exit 1

python dumper.py \
    --config /afs/cern.ch/user/c/ceimthur/dumper-to-salt/config/SM4tops_SR_4class_GN2v01WP85_run3.yaml \
    --convert \
    --convert_sample "$SAMPLE" \
    &> "$LOG_DIR/dumper_${SAMPLE}.log"
        