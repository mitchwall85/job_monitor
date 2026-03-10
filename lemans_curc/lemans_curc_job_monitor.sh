#!/bin/sh
# Monitor convergence and status of lemans jobs on CURC

LOCAL_DIR="/home/mitch/odrive-agent-mount/OneDrive For Business/CUBoulder/NGPDL/job_monitor/lemans_curc"
REMOTE_HOST=miwa6095
REMOTE_USER=login10.rc.colorado.edu

REMOTE_COMMANDS="ls"

output=''
cmd_output=$(ssh $REMOTE_HOST@$REMOTE_USER)
output="$output\n Command: $cmd\n $cmd_output\n"

# save output
echo -e "$output" > "LOCAL_DIR/remote_output.txt"

echo "Results copied"
  


