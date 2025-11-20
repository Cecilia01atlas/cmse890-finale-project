# SM4Tops Workflow

Welcome to the SM4Tops workflow documentation. This project provides a reproducible workflow to start an **MVA (Multivariate Analysis) training** for four-top Monte Carlo (MC) samples using **Snakemake**.

## Introduction

The goal of this workflow is to facilitate MVA training for four-top processes in the ATLAS experiment to improve the separation between signal and background. It includes:

- Preprocessing MC samples with FastFrames
- Producing analysis-ready ntuples
- Submitting jobs safely to the HTCondor batch system
- Automating reproducible training steps for machine learning models

This workflow is designed for researchers who want to:

- Reproduce the training steps easily
- Manage large MC datasets efficiently
- Track and document analysis pipelines

## Workflow Overview

The workflow includes:

**1. Automated environment setup**  
  
- Configures the Python environment and dependencies  
- Prepares FastFrames for processing

**2. Sample processing via FastFrames**  
  
- Reads the FastFrames configuration  
- Submits jobs to HTCondor to process MC samples  

**3. Ntuple generation for analysis**  
  
- Collects processed samples  
- Stores ntuples in EOS space for further analysis  

**4. Support for HTCondor batch system**  
  
- Submits multiple jobs efficiently  
- Monitors job progress and completion  
