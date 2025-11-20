# FAQ

## Q1: Snakemake reports missing output files?

- This usually happens because the output directory is on **EOS or AFS**, which may have some latency in reflecting newly created files.  
  
- **Solutions:**
  - Add the `--latency-wait` option when running Snakemake. Example:
    ```bash
    snakemake -j1 --latency-wait 600
    ```
    This tells Snakemake to wait up to 600 seconds for missing files to appear.
  - Make sure all **Condor jobs** have finished before running Snakemake again. You can check with:
    ```bash
    condor_q
    ```

## Q2: How to safely cancel running Condor jobs?

- Identify the jobs with:
    ```bash
    condor_q
    ```
- Cancel a specific job or job cluster with:
    ```bash
    condor_rm <job_id>
    ```

## Q3: Why do I need absolute paths in the configuration?

- FastFrames and Snakemake both rely on **absolute paths** for reproducibility.
- Using relative paths, especially for EOS/AFS storage, can break the workflow or cause file-not-found errors.

## Q4: What if my logs don’t appear?

- Ensure the log directory exists and is writable.
- If you run Condor jobs, logs may only appear after the job finishes on the batch system.
- Check the wrapper script path and permissions.