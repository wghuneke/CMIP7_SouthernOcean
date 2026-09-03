#!/bin/bash

module load cdo

# Change directory to path of  output files
OUT_PATH="/g/data/x77/wgh581/Post_Process/CMIP6_CMIP7_Subset/"
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

# Diagnostic
var="tos"

# Define paired input directories and output files
INPUT_DIRS=(
#    "/g/data/fs38/publications/CMIP6/CMIP/CSIRO-ARCCSS/ACCESS-CM2/historical/r1i1p1f1/Omon/${var}/gn/latest"
#    "/g/data/fs38/publications/CMIP6/CMIP/CSIRO/ACCESS-ESM1-5/historical/r1i1p1f1/Omon/${var}/gn/latest"
     "/g/data/oi10/replicas/CMIP6/CMIP/AWI/AWI-CM-1-1-MR/historical/r1i1p1f1/Omon/${var}/gn/v20181218"
#    "/g/data/oi10/replicas/CMIP6/CMIP/BCC/BCC-CSM2-MR/historical/r1i1p1f1/Omon/${var}/gn/v20181126"
#    "/g/data/oi10/replicas/CMIP6/CMIP/CAMS/CAMS-CSM1-0/historical/r1i1p1f1/Omon/${var}/gn/v20190708" # no sos variable (need to extract from so)
#    "/g/data/oi10/replicas/CMIP6/CMIP/CCCma/CanESM5/historical/r1i1p1f1/Omon/${var}/gn/v20190429"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NCAR/CESM2/historical/r1i1p1f1/Omon/${var}/gn/v20190308"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NCAR/CESM2-WACCM/historical/r1i1p1f1/Omon/${var}/gn/v20190808"
#    "/g/data/oi10/replicas/CMIP6/CMIP/CMCC/CMCC-CM2-SR5/historical/r1i1p1f1/Omon/${var}/gn/v20200616"
#    "/g/data/oi10/replicas/CMIP6/CMIP/CMCC/CMCC-ESM2/historical/r1i1p1f1/Omon/${var}/gn/v20210114"
#    "/g/data/oi10/replicas/CMIP6/CMIP/CNRM-CERFACS/CNRM-CM6-1/historical/r1i1p1f2/Omon/${var}/gn/v20180917"
#    "/g/data/oi10/replicas/CMIP6/CMIP/CNRM-CERFACS/CNRM-CM6-1-HR/historical/r1i1p1f2/Omon/${var}/gn/v20191021"
#    "/g/data/oi10/replicas/CMIP6/CMIP/CNRM-CERFACS/CNRM-ESM2-1/historical/r1i1p1f2/Omon/${var}/gn/v20181206"
#    "/g/data/oi10/replicas/CMIP6/CMIP/EC-Earth-Consortium/EC-Earth3/historical/r1i1p1f1/Omon/${var}/gn/v20200918"
#    "/g/data/oi10/replicas/CMIP6/CMIP/EC-Earth-Consortium/EC-Earth3-Veg-LR/historical/r1i1p1f1/Omon/${var}/gn/v20200919"
#    "/g/data/oi10/replicas/CMIP6/CMIP/CAS/FGOALS-g3/historical/r1i1p1f1/Omon/${var}/gn/v20191107"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NOAA-GFDL/GFDL-CM4/historical/r1i1p1f1/Omon/${var}/gn/v20180701"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NOAA-GFDL/GFDL-ESM4/historical/r1i1p1f1/Omon/${var}/gn/v20190726"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NASA-GISS/GISS-E2-1-H/historical/r1i1p1f1/Omon/${var}/gn/v20190403"
#    "/g/data/oi10/replicas/CMIP6/CMIP/MOHC/HadGEM3-GC31-LL/historical/r1i1p1f3/Omon/${var}/gn/v20190624"
#    "/g/data/oi10/replicas/CMIP6/CMIP/INM/INM-CM4-8/historical/r1i1p1f1/Omon/${var}/gr1/v20190530"
#    "/g/data/oi10/replicas/CMIP6/CMIP/IPSL/IPSL-CM6A-LR/historical/r1i1p1f1/Omon/${var}/gn/v20180803"
#    "/g/data/oi10/replicas/CMIP6/CMIP/KIOST/KIOST-ESM/historical/r1i1p1f1/Omon/${var}/gr1/v20210601"
#    "/g/data/oi10/replicas/CMIP6/CMIP/MPI-M/MPI-ESM1-2-HR/historical/r1i1p1f1/Omon/${var}/gn/v20190710"
#    "/g/data/oi10/replicas/CMIP6/CMIP/MPI-M/MPI-ESM1-2-LR/historical/r1i1p1f1/Omon/${var}/gn/v20190710"
#    "/g/data/oi10/replicas/CMIP6/CMIP/MRI/MRI-ESM2-0/historical/r1i1p1f1/Omon/${var}/gn/v20190904"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NUIST/NESM3/historical/r1i1p1f1/Omon/${var}/gn/v20190703"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NCC/NorESM2-LM/historical/r1i1p1f1/Omon/${var}/gn/v20190815/"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NCC/NorESM2-MM/historical/r1i1p1f1/Omon/${var}/gn/v20191108"
#    "/g/data/oi10/replicas/CMIP6/CMIP/AS-RCEC/TaiESM1/historical/r1i1p1f1/Omon/${var}/gn/v20200630"
#    "/g/data/oi10/replicas/CMIP6/CMIP/MOHC/UKESM1-0-LL/historical/r1i1p1f2/Omon/${var}/gn/v20190627"
)

OUTPUT_FILES=(
#    "${var}_Omon_ACCESS-CM2_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_ACCESS-ESM1-5_historical_1995_2014_r360x180_SH.nc"
     "${var}_Omon_AWI-CM-1-1-MR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_BCC-CSM2-MR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CAMS-CSM1-0_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CanESM5_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CESM2_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CESM2-WACCM_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CMCC-CM2-SR5_historical_1995_2014_r360x180_SH_n.nc"
#    "${var}_Omon_CMCC-ESM2_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CNRM-CM6-1_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CNRM-CM6-1-HR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CNRM-ESM2-1_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_EC-Earth3_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_EC-Earth3-Veg-LR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_FGOALS-g3_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_GFDL-CM4_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_GFDL-ESM4_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_GISS-E2-1-HR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_HadGEM3-GC31-LL_historical_1995_2014_r360x180_SH_n.nc"
#    "${var}_Omon_INM-CM4-8_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_IPSL-CM6A-LR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_KIOST-ESM_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_MPI-ESM1-2-HR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_MPI-ESM1-2-LR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_MRI-ESM2-0_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_NESM3_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_NorESM2-LM_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_NorESM2-MM_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_TaiESM1_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_UKESM1-0-LL_historical_1995_2014_r360x180_SH.nc"
)

TMP_DIR="./tmp_subset"

for i in "${!INPUT_DIRS[@]}"; do
    INPUT_DIR="${INPUT_DIRS[$i]}"
    OUTPUT_FILE="${OUTPUT_FILES[$i]}"
    echo "========================================="
    echo "Run $((i+1)): $INPUT_DIR -> $OUTPUT_FILE"
    echo "========================================="

    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    for f in "$INPUT_DIR"/*.nc; do
        base=$(basename "$f")
	base=${base/1850/1995} # Change years for output (adjust if subsetting different years)
        echo "Processing $base"

	# --- Step 0: Select variable ---
	run_cdo cdo -selname,${var} "$f" "$TMP_DIR/${base%.nc}_var.nc" \
            || { echo "  selname failed for $base, skipping..."; continue; }

        # --- Step 1: Subset time to select years 1995-2014 ---
        run_cdo cdo selyear,1995/2014  "$TMP_DIR/${base%.nc}_var.nc" "$TMP_DIR/${base%.nc}_time.nc" \
            || { echo "  selyear failed for $base, skipping..."; continue; }

        # --- Step 2: Remap to 360x180 grid ---
        # remapbil (bilinear) for all
        REMAP_METHOD="remapbil"
        run_cdo cdo $REMAP_METHOD,r360x180 "$TMP_DIR/${base%.nc}_time.nc" "$TMP_DIR/${base%.nc}_remap.nc" \
            || { echo "  remap failed for $base, skipping..."; continue; }

        # --- Step 3: Subset latitude (-90 to -40) ---
        run_cdo ncks -d lat,-90.,-40. "$TMP_DIR/${base%.nc}_remap.nc" "$TMP_DIR/${base%.nc}_final.nc" \
            || { echo "  ncks failed for $base, skipping..."; continue; }
    done

    echo "Concatenating all processed files..."
    ncrcat "$TMP_DIR"/*_final.nc "$OUTPUT_FILE"

    echo "Cleaning up temporary files..."
    rm -rf "$TMP_DIR"

    echo "Done! Output saved to $OUTPUT_FILE"
done

echo "All runs complete."

