#!/bin/bash
# script arguments
# 1: Name of Slurm job, defined by user in --job-name flag
# 2: Path to where the job and the submission script exist

source ~/.bashrc
source /etc/profile # makes squeue work with options
module load slurm/blanca

echo
echo "Running Job Resubmission"
echo "Job Name $1"
echo "Job Dir $2"

current_time=$(date +"%Y-%m-%d %H:%M:%S")
job_name="$1"
job_dir="$2"

# Get the job ID of the previous job
previous_job_id="$(squeue -u "miwa6095" -n "$job_name" -o "%i" --noheader)"
echo "Previous Job ID: $previous_job_id"

# Check if the previous job is still running or pending
if [ -n "$previous_job_id" ]; then
  current_time=$(date +"%T")
  echo "Job is still running or pending (Job ID: $previous_job_id) at time: $current_time"
else
  # Resubmit the job preemptable again
  cd $job_dir
  sbatch --export=NONE submitBlanca.sh
  echo "sbatch --export=NONE submitBlanca.sh"
  echo "Job resubmitted at: $current_time"
fi

