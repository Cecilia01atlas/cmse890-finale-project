# Workflow Overview

This project implements a **multi-stage Snakemake workflow** designed to prepare inputs for an MVA training using four-top Monte Carlo samples. This is being accomplished by using external tools like FastFrames, Salt and Umami.

The entire workflow is structured as a **Snakemake DAG**:

---

## Workflow Stages

### 1. Ntuple Production (FastFrames)

- Reads a FastFrames configuration (e.g. `Run3_config_DNN.yml`)
- Submits ntuple production jobs to **HTCondor**
- Stores ntuples in **EOS**
- Skips submission automatically if the ntuple directory already exists

This step is asynchronous: once jobs are submitted, execution continues only after ntuples appear in EOS.
---

### 2. Ntuple Availability Check

- Periodically checks for the presence of the ntuple directory in EOS
- Handles EOS/AFS latency explicitly
- Acts as a synchronization point between batch production and local processing

This allows the workflow to be stopped and resumed safely.

---

### 3. Conversion to HDF5 (dumper-to-SALT)

- Converts FastFrames ntuples into `.h5` files
- Runs once per sample
- Produces sample-level completion flags to ensure reproducibility

---

### 4. Umami Preprocessing

- Runs preprocessing using Umami configuration files
- Processes all folds defined in the preprocessing configuration
- Produces preprocessed datasets ready for MVA training

---

## Workflow State Tracking (Flag Files)

This workflow uses **flag files** (stored in the `flags/` directory) to track progress between stages.

Each major step creates a `.flag` or `.done` file once it has completed successfully.  
These files allow Snakemake to:

- Resume the workflow after interruptions
- Avoid re-running long or expensive steps
- Synchronize asynchronous batch jobs (e.g. HTCondor submissions)

### Important

If you want to **re-run parts of the workflow**, the corresponding flag files must be removed manually.

## Helper Scripts

Several workflow steps are executed via small wrapper scripts located in the `scripts/` directory:

- `run_fastframe.sh` — submits FastFrames ntuple jobs
- `run_dumper.sh` — converts ntuples to HDF5 using dumper-to-SALT
- `run_preprocessing.sh` — runs Umami preprocessing

These scripts must be executable. If you encounter permission errors, run:

```bash
chmod +x scripts/*.sh
```

## Snakemake Rules

Key rules in the workflow include:

- `submit_ntuples`  
  Submits FastFrames jobs (or skips if outputs already exist)

- `wait_for_ntuples`  
  Blocks execution until ntuples are available in EOS

- `run_dumper`  
  Converts ntuples to HDF5 format per sample

- `run_preprocessing`  
  Runs Umami preprocessing once all inputs are ready

- `all`  
  Default entry point that executes the full workflow

---

## Example Snakemake Command

To run the full workflow:

```bash
snakemake -j1 --latency-wait 60
```

To execute only the initial stage (ntuple submission and availability check):

```bash
snakemake stage1-j1 --latency-wait 60
```
