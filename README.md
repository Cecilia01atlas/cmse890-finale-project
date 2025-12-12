# SM4Tops Snakemake Workflow

This repository contains a **Snakemake-based workflow** for preparing inputs to an **MVA training** for four-top Monte Carlo samples in the ATLAS experiment.

The workflow integrates **FastFrames**, **dumper-to-SALT**, and **Umami preprocessing** into a reproducible pipeline.

---

## Workflow Summary

The pipeline performs the following steps:

- **Ntuple production (FastFrames)**  
  Submits HTCondor jobs and stores ntuples in EOS.

- **EOS synchronization**  
  Waits explicitly for ntuples to appear, handling EOS/AFS latency.

- **HDF5 conversion (dumper-to-SALT)**  
  Converts ntuples into `.h5` files, one per sample.

- **Umami preprocessing**  
  Prepares training-ready datasets using fold-based configurations.

Progress is tracked using **flag files**, allowing safe interruption and resumption.

Full documentation for the workflow can be found here:
https://Cecilia01atlas.github.io/cmse890-finale-project/
