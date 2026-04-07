#!/bin/bash
set -euo pipefail

# -- Given the default convergence.dat file from LeMANS, convert to tecplot-compatible format
# -- Adds a variable line and replaces hardcoded text per line into tabs

outfile="tecplot_convergence.dat"

# *.dat: lemans
# *.plt: Monaco
# *_cont.plt: MPC-CONT
# *_part.plt: MPC-PART

input_files=()
for f in convergence.dat convergence.plt convergence_cont.plt convergence_part.plt; do
    if [[ -f "$f" ]]; then
        input_files+=("$f")
    fi
done

if [[ ${#input_files[@]} -eq 0 ]]; then
    echo "No convergence file found"
    exit 1
fi

process_file() {
    local infile="$1"

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
        local first_line
        first_line=$(awk 'NF{print; exit}' "$outfile")

        if printf '%s\n' "$first_line" | grep -q '^V'; then
            echo "Using Monaco Convergence File"

            # Delete zone line if present as second line
            if sed -n '2p' "$outfile" | grep -q '^Z'; then
                sed -i'' '2d' "$outfile"
            fi

            makeGnuConvPlot_monaco_collision
            makeGnuConvPlot_monaco_particle
            makeGnuConvPlot_monaco

        elif printf '%s\n' "$first_line" | grep -Eq '^[[:space:]]*[0-9]+([[:space:]]+|$)'; then
            echo "Using MPC-CONT Convergence File"

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

        #makeGnuConvPlot_monaco_collision
        #makeGnuConvPlot_monaco_particle
        makeGnuConvPlot_monaco

    elif [[ "$infile" == "convergence_cont.plt" ]]; then
        echo "Using MPC-CONT Convergence File"

        sed -i'' '1i VARIABLES = "iter" "Max Res" "Max Res Cell" "L2 Res" "dt" "CFL" "time" "ablw"' "$outfile"
        sed -i'' 's/\t/ /g' "$outfile"

        makeGnuConvPlot_lm_mpc

    else
        echo "Unsupported Convergence File Provided"
        exit 1
    fi
}

for infile in "${input_files[@]}"; do
    process_file "$infile"
done

echo "Done."
