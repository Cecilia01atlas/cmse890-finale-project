## Installation

In order to set up the SM4Tops workflow, the followoing steps are needed:

### 1. Prerequisites

This workflow assumes that all required external software environments are **already installed and configured**.  
The workflow **does not attempt to create or validate these environments automatically**.

In particular, the following setups are required:

- **FastFrames (ATLAS / StatAnalysis)**  
  Used for ntuple production via HTCondor.  
  Requires a working ATLAS environment and a valid FastFrames installation.

- **SALT + dumper-to-SALT**  
  Used to convert FastFrames ntuples into HDF5 files for MVA training.

Please refer to the official SALT documentation for detailed setup instructions:

- **SALT documentation:**  
  https://ftag-salt.docs.cern.ch/setup/

- **Umami preprocessing**  
  Used for preprocessing and fold splitting prior to training.

The workflow assumes that:

- `setup.sh` scripts for FastFrames, SALT, and Umami work when sourced manually
- salt envrionments and packages are installed
- Required CVMFS and ATLAS tools are available
- EOS and AFS paths are accessible
- HTCondor is available for batch submission

If any of these environments are missing or misconfigured, the workflow will fail at runtime.

---

### 2. Clone the workflow repository

The workflow is hosted on GitHub:

```bash
git clone https://github.com/Cecilia01atlas/cmse890-finale-project.git
```

### 3. Clone the required repositories
This workflow relies the following four git repositories from the frag group, wich are hosted on GitLab:
- fastframes
- salt
- dumper-to-salt
- umami-preprocessing 

Access requires CERN credentials! 

```bash
git clone https://gitlab.cern.ch/atlasphys-top/TopPlusX/ANA-TOPQ-2023-43/sm4tops-fastframe.git
git clone ttps://gitlab.cern.ch/atlas-phys/exot/hqt/ana-exot-2022-44/ftag-based-mva/salt.git
git clone https://gitlab.cern.ch/atlas-phys/exot/hqt/ana-exot-2022-44/ftag-based-mva/dumper-to-salt.git
git clone https://gitlab.cern.ch/atlas-phys/exot/hqt/ana-exot-2022-44/ftag-based-mva/umami-preprocessing.git
```

**Note:** make sure to clone all repositories into a directory that matches the path specified in the workflow configuration (workflow_config.yaml)  

### 4. Configure the workflow

The workflow is configured via `workflow_config.yaml`.
It uses a small set of **base paths** (AFS, EOS, project name, analysis tag) from which all tool-specific paths are derived automatically.  

---

#### Base configuration

You must define:

- `afs_root` – Base AFS path for your CERN user  
- `eos_root` – Base EOS path for large outputs  
- `project_name` – Name of the project directory  
- `analysis_tag` – Identifier for the analysis version

---

#### FastFrames (ntuple production)

Controls submission of FastFrames jobs to HTCondor:

- `fastframe_repo` – Path to the FastFrames repository
- `fastframe_config` – FastFrames YAML configuration
- `custom_class` – Custom FastFrames classes
- `ntuples_eos_dir` – EOS directory where ntuples are written

---

#### Dumper-to-SALT (HDF5 conversion)

Converts ntuples into `.h5` files for ML training:

- `samples` – List of physics samples to process
- `h5_output_dir` – EOS directory for generated `.h5` files

---

#### Umami preprocessing

Runs preprocessing over all folds:

- `folds` – List of folds (e.g. `fold0`–`fold3`)
- `preprocessing_config_dir` – Directory with preprocessing YAML configs

---

### 5. Create and activate all envrionments environment

```bash
conda env create -f environment.yaml
conda activate mva-workflow
```

### 6. Test the installation

You can run Snakemake in dry-run mode to check that everything is configured correctly:

```bash
snakemake -n  
```

If paths or permissions are incorrect, Snakemake will report missing input files or directories.
