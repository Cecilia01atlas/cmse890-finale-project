## Installation

Follow these steps to set up the SM4Tops workflow and its dependencies.

### 1. Clone the workflow repository

The workflow is hosted on GitHub:

```bash
git clone https://github.com/Cecilia01atlas/cmse890-finale-project.git
```

### 2. Clone the FastFrame repository
This workflow relies on the FastFrames package to process MC samples. Access requires CERN credentials:  

```bash
git clone https://gitlab.cern.ch/atlasphys-top/TopPlusX/ANA-TOPQ-2023-43/sm4tops-fastframe.git
```

**Note:** make sure to clone FastFrames into a directory that matches the path specified in the workflow configuration (workflow_config.yaml)  

### 3. Configure the workflow

Edit `workflow_config.yaml` to set the following absolute paths:

- `fastframe_repo`: absolute path to the FastFrames repository
- `fastframe_config`: absolute path to the FastFrames YAML configuration
- `custom_class`: absolute path to any custom FastFrames classes
- `ntuples_eos_dir`: absolute path in EOS where ntuples will be stored

### 4. Create and activate the conda environment

```bash
conda env create -f environment.yaml
conda activate mva-workflow
```

### 5. Test the installation

You can run Snakemake in dry-run mode to check that everything is configured correctly:

```bash
snakemake -n  
```

If paths or permissions are incorrect, Snakemake will report missing input files or directories.
