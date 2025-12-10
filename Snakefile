configfile: "workflow_config.yaml"

FASTFRAME_REPO = config["fastframe_repo"]
FASTFRAME_CONFIG = config["fastframe_config"]
CUSTOM_CLASS = config["custom_class"]
NTUPLES_DIR = config["ntuples_eos_dir"]
SAMPLES = config["samples"]

###########################################
# FINAL TARGET
###########################################
rule all:
    input:
        expand("flags/dumper_{sample}.done", sample=SAMPLES)

###########################################
# 1. Submit FastFrames Ntuple Jobs
###########################################
rule submit_ntuples:
    output:
        touch("flags/ntuples_submitted.flag")
    shell:
        """
        ./scripts/run_fastframe.sh logs
        touch flags/ntuples_submitted.flag
        """

###########################################
# 2. Wait for ntuples to appear in EOS
###########################################
rule wait_for_ntuples:
    input:
        "flags/ntuples_submitted.flag"
    output:
        touch("flags/ntuples_ready.flag")
    params:
        ntuple_dir=NTUPLES_DIR
    shell:
        """
        echo "Waiting for ntuples in {params.ntuple_dir} ..."
        while [ ! -d "{params.ntuple_dir}" ]; do
            echo "Ntuples not found yet. Checking again in 60 seconds..."
            sleep 60
        done
        echo "Ntuples found!"
        touch flags/ntuples_ready.flag
        """

###########################################
# 3. Dumper-to-SALT for each sample
###########################################
rule run_dumper:
    input:
        "flags/ntuples_ready.flag"
    output:
        "flags/dumper_{sample}.done"
    params:
        log_dir="logs"
    shell:
        """
        ./scripts/run_dumper.sh {params.log_dir} {wildcards.sample}
        touch flags/dumper_{wildcards.sample}.done
        """
