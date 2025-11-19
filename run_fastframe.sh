#!/bin/bash
# Wrapper to submit FastFrame jobs safely from Snakemake

LOG_DIR="$1"  # first argument: directory to store log
mkdir -p "$LOG_DIR"

# Go to FastFrame repo and source the environment
cd /afs/cern.ch/user/c/ceimthur/sm4tops-fastframe || exit 1
source setup.sh ""       # pass empty argument to avoid $1 error
cd fastframes/python || exit 1

# Run batch_submit.py with automatic 'y' confirmation
echo "y" | python3 batch_submit.py -c /afs/cern.ch/user/c/ceimthur/sm4tops-fastframe/SM4topsConfigs/Run3_config_DNN.yml \
    --step n \
    --custom-class-path /afs/cern.ch/user/c/ceimthur/sm4tops-fastframe/SM4topsSSML \
    &> "$LOG_DIR/produce_ntuples.log"

