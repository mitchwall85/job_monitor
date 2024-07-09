This script is for resubmitting jobs automatically after they are canceled. This is most easily configured using cron to run the script periodically to check if the job ended. `resub_jobs_curc.sh` must be executable.
 
To set up:
1) crontab -e: to edit current crontab jobs
2) Add this line to cron for each job that needs to be resubmitted: `* * * * * <path to script>/resub_jobs_curc.sh <the "--job-name=" from slurm script> <path to job directory> >> <path to a log file to output resubmission outputs>`

   
   Example to check job every minute: `* * * * * /home/miwa6095/job_monitor/resub_jobs_curc/resub_jobs_curc.sh c43SA_1m /rc_scratch/miwa6095/case_43/010_3d_SA_120k_surface_1p5m_cells >> /rc_scratch/miwa6095/case_43/010_3d_SA_120k_surface_1p5m_cells/resub_info.log`
   
4) Save and exit the crontab file.
5) Check the log file to ensure that the script is working.


Using cron:
Each line in the crontab file is a command that will be run at an interval specified by the five characters preceding the command. Find details on formatting here:
https://acquia.my.site.com/s/article/360004224494-Cron-time-string-format
