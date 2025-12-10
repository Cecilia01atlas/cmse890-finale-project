#!/bin/bash

LOG_DIR="$1"
SAMPLE="$2"
mkdir -p "$LOG_DIR"

cd /afs/cern.ch/user/c/ceimthur/dumper-to-salt || exit 1
source setup.sh

python dumper.py --config /afs/cern.ch/user/c/ceimthur/dumper-to-salt/config/SM4tops_SR_4class_GN2v01WP85_run3.yaml \
    --convert --convert_sample "$SAMPLE" \
    &> "$LOG_DIR/dumper_${SAMPLE}.log"
