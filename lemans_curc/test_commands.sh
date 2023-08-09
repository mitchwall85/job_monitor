#/!/bin/sh
#
JOB_IDS=$(squeue -h -u miwa6095 -o "%i")

for JOB_ID in $JOB_IDS; do
  WORKINGDIR=$(scontrol show job $JOB_ID| grep "WorkDir=" | awk -F= '{print $2}')
  echo $WORKINGDIR
  cd $WORKINGDIR
  makeTecplotConvergence_mpc.sh
done

