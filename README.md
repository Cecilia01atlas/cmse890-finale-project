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

**Final note:** I hereby declare that I used AI for the project, specifically ChatGPT 5.2. In more detail, AI was used to help with coding the Snakefile, wrapper files, and configuration file, and subsequently to debug the Snakemake workflow. In addition, it was also used to provide feedback on the structure and grammar of the documentation.
