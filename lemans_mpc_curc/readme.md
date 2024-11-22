## LeMANS MPC CURC
These files will search for running jobs on  CU Research Computing (CURC), create convergence files for them, and plot. 

After cloning this repo to CURC, add the directory to $PATH and make all scripts executable (`chmod +x <script name>`). Then use `job_monitor.sh` from any directory to list convergence data for each running job. Run `makeTecplotConvergence.sh` and `makeGnuConvPlot_total` to do the same thing for an indivdual job regardless if it is running or not. 

Note, the gnuplot path required at the top of the `makeGnuConvplot_*` scripts seems to be user-dependant for some reason... Try these options if it is not working:

* `#!/curc/sw/gnuplot/5.4.1/bin/gnuplot`
* `#!/curc/sw/install/gnuplot/5.4.3/bin/gnuplot`
