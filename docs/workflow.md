# Workflow Overview

The workflow is structured as a **Snakemake DAG**:

**1. Produce Ntuples:**  
  
- Reads the FastFrames configuration (`Run3_config_DNN.yml`)
- Submits jobs to HTCondor to store ntuples
- Stores ntuples in EOS space

**2. Other steps:**    
   Will be added later

## Snakemake Rules

- `all`: Entry point, checks ntuple outputs
- `produce_ntuples`: Submits FastFrames jobs

### Example Snakemake Command

```bash
snakemake -j1 -p
```