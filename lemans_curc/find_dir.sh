 #!/bin/sh
 
 DIRS=$(cat test_commands.sh | ssh miwa6095@login10.rc.colorado.edu)

 echo $DIRS

for DIR in $DIRS; do 

  scp miwa6095@dtn.rc.int.colorado.edu:$DIR/tecplot_convergence.dat .


  # plot files
  gnuplot makeGnuConvPlot_l2.sh

done
