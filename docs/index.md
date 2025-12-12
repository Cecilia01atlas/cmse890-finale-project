# SM4Tops Workflow

Welcome to the SM4Tops workflow documentation. This project provides a reproducible workflow to start a **MVA (Multivariate Analysis) training** for four-top Monte Carlo (MC) samples using **Snakemake**.

## Introduction

The goal of this workflow is to facilitate MVA training for four-top processes in the ATLAS experiment to improve the separation between signal and background. It includes:

- Preprocessing MC samples with FastFrames
- Producing analysis-ready ntuples (Root files) by submitting jobs to HTCondor
- Converting the ntuples into h5 files through dumper
- Preparation of data that fits the input format for the training later in SALT using umami
- Automating reproducible training steps for machine learning models

This workflow is designed for researchers who want to:

- Reproduce MVA training inputs reliably
- Process large MC samples more efficiently
- Resume long-running workflows safely

## Workflow Overview

The workflow contains the following steps:

1. **Ntuple production** using FastFrames and HTCondor  
2. **Synchronization** with EOS to ensure ntuples are available  
3. **Conversion** of ntuples into HDF5 format for machine learning  
4. **Preprocessing** of inputs using Umami for downstream training 