#!/bin/bash

module load cdo
module load nco

# Change directory to path of  output files
OUT_PATH="/g/data/lg87/wgh581/CMIP6_CMIP7_Subset/CMIP7/"

# Experiment
exp="esm-hist" # e.g. "historical" or "esm-hist"
# Diagnostic
var="siconc"
# Realm
if [ "$var" = "siconc" ]; then
    realm="tavg-u-hxy-u"
else
    realm="tavg-u-hxy-sea"
fi

OUT_PATH="${OUT_PATH}${exp}/${var}/"
mkdir -p "${OUT_PATH}"
cd ${OUT_PATH}

echo "$(pwd)"

# Retry in case of any gadi glitches
run_cdo() {
    local attempt=1
    local max_attempts=3
    until "$@"; do
        if [ $attempt -ge $max_attempts ]; then
            echo "Command failed after $max_attempts attempts: $*"
            return 1
        fi
        echo "Command failed (attempt $attempt), retrying in 5s..."
        sleep 5
        attempt=$((attempt+1))
    done
}

# Input file directory path (CMIP7 ACCESS-ESM1-6 and replica)
access="/g/data/im55/publications/MIP-DRS7/CMIP7/CMIP"
replica="/g/data/ib12/replicas/MIP-DRS7/CMIP7/CMIP"

# Select model list and output names based on experiment
if [ "$exp" == "historical" ]; then
    INPUT_DIRS=(
        "${access}/ACCESS-Consortium/ACCESS-ESM1-6/${exp}/r1i1p1f1/glb/mon/${var}/${realm}/g118/latest"
        "${replica}/CAS/CAS-ESM2-1-CSM/${exp}/r1i1p1f1/glb/mon/${var}/${realm}/g207/v*" 
        "${replica}/CCCma/CanESM6-0-MR/${exp}/r1i1p1f1/glb/mon/${var}/${realm}/g147/v*" 
        "${replica}/UKNCSP/UKCM2-0-LL/${exp}/r2i1p1f1/glb/mon/${var}/${realm}/g126/v*"
        "${replica}/UKNCSP/UKCM2a-0-HH/${exp}/r1i1p1f1/glb/mon/${var}/${realm}/g154/v*" 
	"${replica}/UKNCSP/UKESM1-3-LL/${exp}/r1i1p1f1/glb/mon/${var}/${realm}/g126/v*" 
    )
    OUTPUT_FILES=(
        "${var}_ACCESS-ESM1-6_${exp}_r360x180_SH.nc"
        "${var}_CAS-ESM2-1-CSM_${exp}_r360x180_SH.nc"
        "${var}_CanESM6-0-MR_${exp}_r360x180_SH.nc"
        "${var}_UKCM2-0-LL_${exp}_r360x180_SH.nc"
        "${var}_UKCM2a-0-HH_${exp}_r360x180_SH.nc"
        "${var}_UKESM1-3-LL_${exp}_r360x180_SH.nc"
    )
elif [ "$exp" == "esm-hist" ]; then
    INPUT_DIRS=(
        "${access}/ACCESS-Consortium/ACCESS-ESM1-6/${exp}/r1i1p1f1/glb/mon/${var}/${realm}/g118/latest"
        "${replica}/CCCma/CanESM5-1/${exp}/r1i1p2f1/glb/mon/${var}/${realm}/g127/v*"
        "${replica}/CCCma/CanESM6-0-MR/${exp}/r1i1p1f1/glb/mon/${var}/${realm}/g147/v*"
        "${replica}/CNRM-CERFACS/CNRM-ESM2-1e/${exp}/r6i1p1f1/glb/mon/${var}/${realm}/g102/v*"
        "${replica}/EC-Earth-Consortium/EC-Earth3-ESM-1-1/${exp}/r1i1p1f1/glb/mon/${var}/${realm}/g102/v*"
        "${replica}/UKNCSP/UKESM1-3-LL/${exp}/r1i1p1f1/glb/mon/${var}/${realm}/g126/v*"
    )
    OUTPUT_FILES=(
        "${var}_ACCESS-ESM1-6_${exp}_r360x180_SH.nc"
        "${var}_CanESM5-1_${exp}_r360x180_SH.nc"
        "${var}_CanESM6-0-MR_${exp}_r360x180_SH.nc"
        "${var}_CNRM-ESM2-1e_${exp}_r360x180_SH.nc"
        "${var}_EC-Earth3-ESM-1-1_${exp}_r360x180_SH.nc"
        "${var}_UKESM1-3-LL_${exp}_r360x180_SH.nc"
    )
else
    echo "Unknown experiment: '${exp}'. This script handles scen7-h|scen7-vl|esm-scen7-h|esm-scen7-vl only."
    exit 1
fi

TMP_DIR="./tmp_subset"


for i in "${!INPUT_DIRS[@]}"; do
    INPUT_PATTERN="${INPUT_DIRS[$i]}"
    OUTPUT_FILE="${OUTPUT_FILES[$i]}"

    # Resolve v* wildcard to the newest version directory
    INPUT_DIR=$(ls -d ${INPUT_PATTERN} 2>/dev/null | sort | tail -n 1)
    if [ -z "$INPUT_DIR" ]; then
        echo "=== Run $((i+1)): NO VERSION MATCHED: $INPUT_PATTERN"
        continue
    fi

    # Skip models whose directory contains no .nc files
    if ! compgen -G "$INPUT_DIR/*.nc" > /dev/null; then
        echo "  No .nc files found in $INPUT_DIR, skipping..."
        continue
    fi

    echo "========================================="
    echo "Run $((i+1)): $INPUT_DIR -> $OUTPUT_FILE"
    echo "========================================="

    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    for f in "$INPUT_DIR"/*.nc; do
        base=$(basename "$f")
	base=${base/1850/1995} # Change years for output (adjust if subsetting different years)
        echo "Processing $base"

        # --- Step 00: Skip files that can't contain 1995-2014 ---
        dates=$(basename "$f" .nc); dates=${dates##*_}
        fstart=${dates%-*}; fend=${dates#*-}
        if [ "${fstart:0:4}" -gt 2014 ] || [ "${fend:0:4}" -lt 1995 ]; then
            echo "  $base outside 1995-2014, skipping..."
            continue
        fi

	# --- Step 0: Select variable ---
	run_cdo cdo -selname,${var} "$f" "$TMP_DIR/${base%.nc}_var.nc" \
            || { echo "  selname failed for $base, skipping..."; continue; }

        # --- Step 1: Subset time to select years 1995-2014 ---
        run_cdo cdo selyear,1995/2014  "$TMP_DIR/${base%.nc}_var.nc" "$TMP_DIR/${base%.nc}_time.nc" \
            || { echo "  selyear failed for $base, skipping..."; continue; }

        # --- Step 2: Remap to 360x180 grid ---
	REMAP_METHOD="remapbil"
        FALLBACK_METHOD="remapcon"

        # Try bilinear first
        if ! run_cdo cdo $REMAP_METHOD,r360x180 "$TMP_DIR/${base%.nc}_time.nc" "$TMP_DIR/${base%.nc}_remap.nc"; then
            echo "  $REMAP_METHOD failed for $base, trying $FALLBACK_METHOD..."
            # Try conservative remapping
            if ! run_cdo cdo $FALLBACK_METHOD,r360x180 "$TMP_DIR/${base%.nc}_time.nc" "$TMP_DIR/${base%.nc}_remap.nc"; then
                echo "  remap failed for $base (both methods), skipping..."
                continue
            fi
        fi

        # --- Step 3: Subset latitude (-90 to -30) ---
        run_cdo ncks -d lat,-90.,-30. "$TMP_DIR/${base%.nc}_remap.nc" "$TMP_DIR/${base%.nc}_final.nc" \
            || { echo "  ncks failed for $base, skipping..."; continue; }
    done

    echo "Concatenating all processed files..."
    ncrcat "$TMP_DIR"/*_final.nc "$OUTPUT_FILE"

    echo "Cleaning up temporary files..."
    rm -rf "$TMP_DIR"

    echo "Done! Output saved to $OUTPUT_FILE"
done

echo "All runs complete."

