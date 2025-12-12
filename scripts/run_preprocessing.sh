#!/bin/bash
# Wrapper to preprocess the HD5 files for the training later

LOG_DIR="$1"
LOG_DIR=$(readlink -f "$LOG_DIR")
mkdir -p "$LOG_DIR"

# --- Load ATLAS environment (needed for setup.sh) ---
export ATLAS_LOCAL_ROOT_BASE="/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase"
source $ATLAS_LOCAL_ROOT_BASE/user/atlasLocalSetup.sh --quiet

# --- Load umami preprocessing environment ---
cd /afs/cern.ch/user/c/ceimthur/umami-preprocessing || exit 1
source setup.sh

# --- Run the official convert.sh to loops over all configuration files for every fold ---
cd /afs/cern.ch/user/c/ceimthur/umami-preprocessing/scripts
echo "Running preprocessing for ALL folds using convert.sh ..."
bash convert.sh &> "${LOG_DIR}/preprocess_all.log"

if [[ $? -ne 0 ]]; then
    echo "ERROR during preprocessing — see log: ${LOG_DIR}/preprocess_all.log"
    exit 1
fi

echo "Preprocessing completed successfully."
