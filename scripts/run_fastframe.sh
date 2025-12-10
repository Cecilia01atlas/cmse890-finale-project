#!/bin/bash
# Wrapper to submit FastFrame jobs safely from Snakemake

# First argument = log directory (may be relative)
LOG_DIR="$1"

# Convert to absolute path
LOG_DIR=$(readlink -f "$LOG_DIR")

# Create log directory
mkdir -p "$LOG_DIR"

# Go to FastFrame repo and source the environment with the setup.sh file
cd /afs/cern.ch/user/c/ceimthur/sm4tops-fastframe || exit 1
source setup.sh ""
cd fastframes/python || exit 1

echo "y" | python3 batch_submit.py \
    -c /afs/cern.ch/user/c/ceimthur/sm4tops-fastframe/SM4topsConfigs/Run3_config_DNN.yml \
    --step n \
    --sample tttt \
    --custom-class-path /afs/cern.ch/user/c/ceimthur/sm4tops-fastframe/SM4topsSSML \
    &> "$LOG_DIR/produce_ntuples.log"
