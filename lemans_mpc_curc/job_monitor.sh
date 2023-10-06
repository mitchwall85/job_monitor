#!/bin/bash
source ~/.bashrc

# find pwd of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# find job IDs from slurm
JOB_IDS=$(squeue -h -u miwa6095 -o "%i")

# loop over running jobs and plot
for JOB_ID in $JOB_IDS; do

  echo '############################################'
  echo "jobid: $JOB_ID"

  # fetch working directory
  WORKINGDIR=$(scontrol show job $JOB_ID| grep "WorkDir=" | awk -F= '{print $2}')
  echo Job Dir: $WORKINGDIR
  
  # check working directory exists
  if [[ -d "$WORKINGDIR" ]]; then
    # change to working directory
    cd $WORKINGDIR || continue

    # execute plotting scripts
    echo 'Making Convergence File'
    $SCRIPT_DIR/makeTecplotConvergence.sh
    echo 'Plot Residuals and CFL'
    $SCRIPT_DIR/makeGnuConvPlot_total    

  else
    echo
    echo "No Convergence file in $WORKINGDIR"
  fi

done



