 #!/bin/sh
 
 DIRS=$(cat test_commands.sh | ssh miwa6095@login10.rc.colorado.edu)

 echo "\n" 
 echo "\n"
 echo $DIRS

for DIR in $DIRS; do 

  scp miwa6095@dtn.rc.int.colorado.edu:$DIR/tecplot_convergence.dat .

done
