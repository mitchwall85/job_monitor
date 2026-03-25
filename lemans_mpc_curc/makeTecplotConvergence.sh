#!/bin/bash
set -euo pipefail

# -- Given the default convergence.dat file from LeMANS, convert to tecplot-compatible format
# -- Adds a variable line and replaces hardcoded text per line into tabs

infile="convergence.dat"
outfile="tecplot_convergence.dat"

# check if MPC or LeMANS format files work
if [[ ! -f "$infile" ]]; then
    infile="convergence.plt"
    if [[ ! -f "$infile" ]]; then
        infile="convergence_part.plt"  # for the case of a MPC-PART case
        if [[ ! -f "$infile" ]]; then
            printf 'No file %s found, error\n' "$infile"
            exit 1
        fi
    fi
fi

echo "Input file: $infile"
echo "Output file: $outfile"

# -- Copy, will clobber
cp "$infile" "$outfile"

if [[ "$infile" == "convergence.dat" ]]; then
    echo "Using LeMANS Convergence File"

    sed -i'' '1i VARIABLES = "iter" "Max Res" "Max Res Cell" "L2 Res" "dt" "CFL" "time" "ablw"' "$outfile"
    sed -i'' 's/ITER= //g' "$outfile"
    sed -i'' 's/MAX. RES.=//g' "$outfile"
    sed -i'' 's/at i=//g' "$outfile"
    sed -i'' 's/L2 RES.=//g' "$outfile"
    sed -i'' 's/dt\[i\]=//g' "$outfile"
    sed -i'' 's/cfl=//g' "$outfile"
    sed -i'' 's/time=//g' "$outfile"
    sed -i'' 's/ablw=//g' "$outfile"

    makeGnuConvPlot_lm_mpc

elif [[ "$infile" == "convergence.plt" ]]; then

    if head -n 1 "$outfile" | grep -q '^V'; then
        echo "Using Monaco Convergence File"

        # Delete zone line if present as second line
        if sed -n '2p' "$outfile" | grep -q '^Z'; then
            sed -i'' '2d' "$outfile"
        fi

        makeGnuConvPlot_monaco_collision
        makeGnuConvPlot_monaco_particle
        makeGnuConvPlot_monaco

    elif head -n 1 "$outfile" | grep -q '^1'; then
        echo "Using MPC Convergence File"

        sed -i'' '1i VARIABLES = "iter" "Max Res" "Max Res Cell" "L2 Res" "dt" "CFL" "time" "ablw"' "$outfile"
        sed -i'' 's/\t/ /g' "$outfile"

        makeGnuConvPlot_lm_mpc

    else
        echo "Unsupported convergence.plt format"
        exit 1
    fi

elif [[ "$infile" == "convergence_part.plt" ]]; then
    echo "MPC-PART convergence File"

    if sed -n '2p' "$outfile" | grep -q '^Z'; then
        sed -i'' '2d' "$outfile"
    fi

    makeGnuConvPlot_monaco_collision
    makeGnuConvPlot_monaco_particle
    makeGnuConvPlot_monaco

else
    echo "Unsupported Convergence File Provided"
    exit 1
fi

echo "Done."
