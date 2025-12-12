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

## Q3: What if my logs don’t appear? 

- Ensure the log directory exists and is writable.
- If you run Condor jobs, logs may only appear after the job finishes on the batch system.
- Check the wrapper script path and permissions.

## Q4: Why does Snakemake skip the ntuple submission step?  
  
If the ntuple directory already exists in EOS:  
- Submission is skipped  
- A message is printed  
- he workflow continues safely  
  
This prevents accidental double submission to HTCondor.

## Q5: Snakemake says “Nothing to be done” but I expected more steps to run  
This workflow uses flag files in the flags/ directory to track progress. If a flag exists, Snakemake assumes that step is complete.
  
- **Solution:**
To re-run parts of the workflow, remove the flag files:  
    ```bash
    rm flags/*.flag  
    rm flags/*.done
    ```