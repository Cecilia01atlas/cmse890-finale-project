import os
from pathlib import Path

configfile: "workflow_config.yaml"

# ==========================================================
# PATH EXPANSION UTILITIES
# ==========================================================

def p(template):
    """Expand config templates safely."""
    return template.format(**config)

AFS_ROOT = p(config["afs_root"])
EOS_ROOT = p(config["eos_root"])

PROJECT = config["project_name"]
TAG = config["analysis_tag"]

AFS_PROJECT = f"{AFS_ROOT}/{PROJECT}"
EOS_PROJECT = f"{EOS_ROOT}/{PROJECT}"

# ==========================================================
# DERIVED PATHS
# ==========================================================

FASTFRAME_REPO = f"{AFS_ROOT}/{config['repos']['fastframe']}"
DUMPER_REPO    = f"{AFS_ROOT}/{config['repos']['dumper']}"
UMAMI_REPO     = f"{AFS_ROOT}/{config['repos']['umami']}"

FASTFRAME_CONFIG = f"{FASTFRAME_REPO}/{config['fastframe']['config']}"
CUSTOM_CLASS     = f"{FASTFRAME_REPO}/{config['fastframe']['custom_class']}"

NTUPLES_DIR = f"{EOS_PROJECT}/{TAG}/ntuples"
OUTPUT_DIR  = f"{EOS_PROJECT}/{TAG}/output"
H5_DIR      = f"{OUTPUT_DIR}/Samples"

CONF_DIR = f"{UMAMI_REPO}/{config['preprocessing_config_subdir']}"

SAMPLES = config["samples"]
FOLDS   = config["folds"]

# ==========================================================
# FINAL TARGET
# ==========================================================

rule all:
    input:
        "flags/preprocessing.done"

# ======================================= 
# STAGE 1 TARGET (OPTIONAL MANUAL STOP)
# ========================================
rule stage1:
    input:
        "flags/ntuples_ready.flag"


# ==========================================================
# RULE 1 — SUBMIT FASTFRAME NTUPLES
# ==========================================================

rule submit_ntuples:
    output:
        "flags/ntuples_submitted.flag"
    shell:
        """
        mkdir -p flags logs

        echo "[FASTFRAME] Checking ntuple directory:"
        echo "  {NTUPLES_DIR}"

        if [ -d "{NTUPLES_DIR}" ]; then
            echo "[FASTFRAME] Ntuples already exist — skipping submission"
        else
            echo "[FASTFRAME] Submitting FastFrames jobs"
            ./scripts/run_fastframe.sh logs
        fi

        touch {output}
        """

# ==========================================================
# RULE 2 — WAIT FOR NTUPLES (EOS / CONDOR)
# ==========================================================

rule wait_for_ntuples:
    input:
        "flags/ntuples_submitted.flag"
    output:
        "flags/ntuples_ready.flag"
    shell:
        """
        echo "[WAIT] Waiting for ntuples in {NTUPLES_DIR}"

        while [ ! -d "{NTUPLES_DIR}" ]; do
            echo "[WAIT] Not ready yet — sleeping 60s"
            sleep 60
        done

        echo "[WAIT] Ntuples found"
        touch {output}
        """

# ===========================================================
# RULE 3 — Converting the ntuples to HD5 files: DUMPER → SALT
# ===========================================================

rule run_dumper:
    input:
        "flags/ntuples_ready.flag"
    output:
        "flags/dumper_{sample}.done"
    params:
        log_dir="logs"
    shell:
        """
        mkdir -p {params.log_dir}

        echo "[DUMPER] Processing sample {wildcards.sample}"
        ./scripts/run_dumper.sh {params.log_dir} {wildcards.sample}

        touch {output}
        """

# ==========================================================
# RULE 4 — UMAMI PREPROCESSING (ALL FOLDS)
# ==========================================================

rule run_preprocessing:
    input:
        expand("flags/dumper_{sample}.done", sample=SAMPLES)
    output:
        "flags/preprocessing.done"
    params:
        log_dir="logs"
    shell:
        """
        mkdir -p {params.log_dir}

        echo "[PREPROCESS] Running Umami preprocessing"
        ./scripts/run_preprocessing.sh {params.log_dir}

        touch {output}
        """
