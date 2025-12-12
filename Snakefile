default_target: all

configfile: "workflow_config.yaml"

FASTFRAME_REPO = config["fastframe_repo"]
FASTFRAME_CONFIG = config["fastframe_config"]
CUSTOM_CLASS = config["custom_class"]
NTUPLES_DIR = config["ntuples_eos_dir"]
SAMPLES = config["samples"]
CONF_DIR = config["preprocessing_config_dir"]

###########################################
# MAIN TARGETS
###########################################

# Full workflow (default)
rule all:
    input:
        "flags/preprocessing.done"

# Stage 1 target: ONLY submit ntuples and stop.
rule stage1:
    input:
        "flags/ntuples_ready.flag"


###############################################
# RULE 1 — Submit FastFrames Ntuple Jobs
###############################################
rule submit_ntuples:
    output:
        touch("flags/ntuples_submitted.flag")
    params:
        ntuple_dir = NTUPLES_DIR
    shell:
        """
        if [ -d "{params.ntuple_dir}" ]; then
            echo "[FASTFRAME] Ntuple directory already exists. Skipping submission."
        else
            echo "[FASTFRAME] Submitting ntuple jobs to Condor..."
            ./scripts/run_fastframe.sh logs
            echo "[FASTFRAME] Submission done."
        fi

        touch flags/ntuples_submitted.flag
        """


###############################################
# RULE 2 — Wait for ntuples to appear in EOS
###############################################
rule wait_for_ntuples:
    input:
        "flags/ntuples_submitted.flag"
    output:
        touch("flags/ntuples_ready.flag")
    params:
        ntuple_dir = NTUPLES_DIR
    shell:
        """
        echo "[WAIT] Checking for ntuples in {params.ntuple_dir}"
        echo "[WAIT] Snakemake will pause here until directory appears."
        while [ ! -d "{params.ntuple_dir}" ]; do
            echo "[WAIT] Ntuples not found yet. Sleeping 60 seconds..."
            sleep 60
        done
        echo "[WAIT] Ntuples found!"
        touch flags/ntuples_ready.flag
        """


###############################################
# RULE 3 — Dumper-to-SALT for each sample
###############################################
rule run_dumper:
    input:
        "flags/ntuples_ready.flag"
    output:
        "flags/dumper_{sample}.done"
    params:
        log_dir = "logs"
    shell:
        """
        mkdir -p {params.log_dir}
        echo "[DUMPER] Converting sample {wildcards.sample}"
        ./scripts/run_dumper.sh {params.log_dir} {wildcards.sample}
        touch flags/dumper_{wildcards.sample}.done
        """


###############################################
# RULE 4 — Umami preprocessing (all samples)
###############################################
rule run_preprocessing:
    input:
        expand("flags/dumper_{sample}.done", sample=SAMPLES)
    output:
        touch("flags/preprocessing.done")
    params:
        log_dir = "logs"
    shell:
        """
        mkdir -p {params.log_dir}
        echo "[PREPROCESS] Running Umami preprocessing over all folds"
        ./scripts/run_preprocessing.sh {params.log_dir}
        touch flags/preprocessing.done
        """
