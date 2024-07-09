This script is for resubmitting jobs automatically after they are canceled. This is most easily configured using crontab to run the script periodically to check if the job ended. `resub_jobs_curc.sh` must be executable.
 
To set up:
1) crontab -e: to edit current crontab jobs
2) Add this line to crontab for each job that needs to be resubmitted: `* * * * * <path to script>/resub_jobs_curc.sh <--job-name from slurm script> <path to job directory> >> <path to a log file to output resubmission outputs>`
   Example to check job ever minute: `* * * * * /home/miwa6095/job_monitor/resub_jobs_curc/resub_jobs_curc.sh c43SA_1m /rc_scratch/miwa6095/case_43/010_3d_SA_120k_surface_1p5m_cells >> /rc_scratch/miwa6095/case_43/010_3d_SA_120k_surface_1p5m_cells/resub_info.log`
4) Save and exit the crontab file.
5) Check the log file to ensure that script is working.
