configfile: "workflow_config.yaml"

FASTFRAME_REPO = config["fastframe_repo"]
FASTFRAME_CONFIG = config["fastframe_config"]
CUSTOM_CLASS = config["custom_class"]
NTUPLES_DIR = config["ntuples_eos_dir"]

rule all:
    input:
        NTUPLES_DIR

rule produce_ntuples:
    input:
        config=FASTFRAME_CONFIG
    output:
        directory(NTUPLES_DIR)
    params:
        log_dir="logs"
    shell:
        """
        ./run_fastframe.sh /afs/cern.ch/user/c/ceimthur/mva-workflow/logs
        """
