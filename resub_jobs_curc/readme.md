This script is for resubmissing jobs automatically after they are cancelled. This is most easily configured using crontab to run the script periodically to check if the job ended.
 
To set up with crontab:
1) crontab -e: to edit current crontab jobs
2) * * * * * <path to script>/resub_jobs_curc.sh <job name from --job-name> <path to job directory> >> <path to a log file in the job directory to output resubmission outputs>
3) save and exit crontab file

Notes:
resub_jobs_curc.sh must be executable
