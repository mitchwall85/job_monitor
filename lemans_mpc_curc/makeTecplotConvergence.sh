#!/bin/bash

# -- Given the default convergence.dat file from LeMANS, convert to tecplot-compatible format
# -- Adds a variable line and replaces hardcoded text per line into tabs


infile="convergence.dat"
outfile="tecplot_convergence.dat"

# check if MPC or LeMANS format files work
if [[ ! -f $infile ]]; then
  infile="convergence.plt"
  if [[ ! -f $infile ]]; then
    printf "No file $infile found, error\n"
    exit 1
  fi
fi

# -- Copy, will clobber
cp $infile $outfile

# -- Add variables line at top
sed -i'' '1i VARIABLES = "iter" "Max Res" "Max Res Cell" "L2 Res" "dt" "CFL" "time" "ablw"' $outfile

if [ $infile = "convergence.dat" ]; then
  # -- Find and replace each text that exists in all lines with tabs
  echo "Using LeMANS Convergence File"
  sed -i'' 's/ITER= //g' $outfile
  sed -i'' 's/MAX. RES.=//g' $outfile
  sed -i'' 's/at i=//g' $outfile
  sed -i'' 's/L2 RES.=//g' $outfile
  sed -i'' 's/dt\[i\]=//g' $outfile
  sed -i'' 's/cfl=//g' $outfile
  sed -i'' 's/time=//g' $outfile
  sed -i'' 's/ablw=//g' $outfile

elif [ $infile = "convergence.plt" ]; then
  echo "Using MPC Convergence File"
  sed -i 's/\t/ /g' $outfile

else
  echo "Unsupported Convergence File Provided"

fi
