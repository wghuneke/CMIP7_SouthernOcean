#!/bin/bash

module load cdo

# Change directory to path of  output files
OUT_PATH="/g/data/lg87/wgh581/CMIP6_CMIP7_Subset/CMIP6/historical/"

# Diagnostic
var="mlotst"

OUT_PATH="${OUT_PATH}${var}/"
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


# Define paired input directories and output files
INPUT_DIRS=(
#    "/g/data/fs38/publications/CMIP6/CMIP/CSIRO-ARCCSS/ACCESS-CM2/historical/r1i1p1f1/Omon/${var}/gn/latest"
#    "/g/data/fs38/publications/CMIP6/CMIP/CSIRO/ACCESS-ESM1-5/historical/r1i1p1f1/Omon/${var}/gn/latest"
#    "/g/data/oi10/replicas/CMIP6/CMIP/AWI/AWI-CM-1-1-MR/historical/r1i1p1f1/Omon/${var}/gn/v20181218"
#    "/g/data/oi10/replicas/CMIP6/CMIP/AWI/AWI-ESM-1-1-LR/historical/r1i1p1f1/Omon/${var}/gn/v20200212"
    "/g/data/oi10/replicas/CMIP6/CMIP/BCC/BCC-CSM2-MR/historical/r1i1p1f1/Omon/${var}/gn/v20181126"
    "/g/data/oi10/replicas/CMIP6/CMIP/BCC/BCC-ESM1/historical/r1i1p1f1/Omon/${var}/gn/v20181129"
#    "/g/data/oi10/replicas/CMIP6/CMIP/CAMS/CAMS-CSM1-0/historical/r1i1p1f1/Omon/${var}/gn/v20190708" 
    "/g/data/oi10/replicas/CMIP6/CMIP/CAS/CAS-ESM2-0/historical/r1i1p1f1/Omon/${var}/gn/v20201228" 
#    "/g/data/oi10/replicas/CMIP6/CMIP/CAS/FGOALS-f3-L/historical/r1i1p1f1/Omon/${var}/gn/v20191007" 
    "/g/data/oi10/replicas/CMIP6/CMIP/CAS/FGOALS-g3/historical/r1i1p1f1/Omon/${var}/gn/v20191106" 
#    "/g/data/oi10/replicas/CMIP6/CMIP/CCCma/CanESM5/historical/r1i1p1f1/Omon/${var}/gn/v20190429"
    "/g/data/oi10/replicas/CMIP6/CMIP/CCCR-IITM/IITM-ESM/historical/r1i1p1f1/Omon/${var}/gn/v20200915"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NCAR/CESM2/historical/r1i1p1f1/Omon/${var}/gn/v20190308"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NCAR/CESM2-WACCM/historical/r1i1p1f1/Omon/${var}/gn/v20190808"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NCAR/CESM2-FV2/historical/r1i1p1f1/Omon/${var}/gn/v20191120"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NCAR/CESM2-WACCM-FV2/historical/r1i1p1f1/Omon/${var}/gn/v20191120"
#    "/g/data/oi10/replicas/CMIP6/CMIP/CMCC/CMCC-CM2-HR4/historical/r1i1p1f1/Omon/${var}/gn/v20200904"
#    "/g/data/oi10/replicas/CMIP6/CMIP/CMCC/CMCC-CM2-SR5/historical/r1i1p1f1/Omon/${var}/gn/v20200616"
#    "/g/data/oi10/replicas/CMIP6/CMIP/CMCC/CMCC-ESM2/historical/r1i1p1f1/Omon/${var}/gn/v20210114"
    "/g/data/oi10/replicas/CMIP6/CMIP/CNRM-CERFACS/CNRM-CM6-1/historical/r1i1p1f2/Omon/${var}/gn/v20180917"
    "/g/data/oi10/replicas/CMIP6/CMIP/CNRM-CERFACS/CNRM-CM6-1-HR/historical/r1i1p1f2/Omon/${var}/gn/v20191021"
    "/g/data/oi10/replicas/CMIP6/CMIP/CNRM-CERFACS/CNRM-ESM2-1/historical/r1i1p1f2/Omon/${var}/gn/v20181206"
#    "/g/data/oi10/replicas/CMIP6/CMIP/EC-Earth-Consortium/EC-Earth3/historical/r1i1p1f1/Omon/${var}/gn/v20200918"
#    "/g/data/oi10/replicas/CMIP6/CMIP/EC-Earth-Consortium/EC-Earth3-Veg-LR/historical/r1i1p1f1/Omon/${var}/gn/v20200919"
#    "/g/data/oi10/replicas/CMIP6/CMIP/E3SM-Project/E3SM-1-0/historical/r1i1p1f1/Omon/${var}/gr/v20190826"
    "/g/data/oi10/replicas/CMIP6/CMIP/FIO-QLNM/FIO-ESM-2-0/historical/r1i1p1f1/Omon/${var}/gn/v20191122"
    "/g/data/oi10/replicas/CMIP6/CMIP/NOAA-GFDL/GFDL-CM4/historical/r1i1p1f1/Omon/${var}/gn/v20180701"
    "/g/data/oi10/replicas/CMIP6/CMIP/NOAA-GFDL/GFDL-ESM4/historical/r1i1p1f1/Omon/${var}/gn/v20190726"
    "/g/data/oi10/replicas/CMIP6/CMIP/NASA-GISS/GISS-E2-1-H/historical/r1i1p1f1/Omon/${var}/gn/v20190403"
    "/g/data/oi10/replicas/CMIP6/CMIP/NASA-GISS/GISS-E2-1-G/historical/r1i1p1f1/Omon/${var}/gn/v20180827"
    "/g/data/oi10/replicas/CMIP6/CMIP/MOHC/HadGEM3-GC31-LL/historical/r1i1p1f3/Omon/${var}/gn/v20190624"
    "/g/data/oi10/replicas/CMIP6/CMIP/MOHC/HadGEM3-GC31-MM/historical/r1i1p1f3/Omon/${var}/gn/v20191207"
    "/g/data/oi10/replicas/CMIP6/CMIP/INM/INM-CM4-8/historical/r1i1p1f1/Omon/${var}/gr1/v20190530"
    "/g/data/oi10/replicas/CMIP6/CMIP/INM/INM-CM5-0/historical/r1i1p1f1/Omon/${var}/gr1/v20190610"
#    "/g/data/oi10/replicas/CMIP6/CMIP/IPSL/IPSL-CM6A-LR/historical/r1i1p1f1/Omon/${var}/gn/v20180803"
#    "/g/data/oi10/replicas/CMIP6/CMIP/KIOST/KIOST-ESM/historical/r1i1p1f1/Omon/${var}/gr1/v20210601"
#    "/g/data/oi10/replicas/CMIP6/CMIP/MPI-M/MPI-ESM1-2-HR/historical/r1i1p1f1/Omon/${var}/gn/v20190710"
#    "/g/data/oi10/replicas/CMIP6/CMIP/MPI-M/MPI-ESM1-2-LR/historical/r1i1p1f1/Omon/${var}/gn/v20190710"
#    "/g/data/oi10/replicas/CMIP6/CMIP/MPI-M/ICON-ESM-LR/historical/r1i1p1f1/Omon/${var}/gn/v20210215"
    "/g/data/oi10/replicas/CMIP6/CMIP/MRI/MRI-ESM2-0/historical/r1i1p1f1/Omon/${var}/gn/v20191205"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NUIST/NESM3/historical/r1i1p1f1/Omon/${var}/gn/v20190703"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NCC/NorESM2-LM/historical/r1i1p1f1/Omon/${var}/gn/v20190815/"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NCC/NorESM2-MM/historical/r1i1p1f1/Omon/${var}/gn/v20191108"
#    "/g/data/oi10/replicas/CMIP6/CMIP/NCC/NorCPM1/historical/r1i1p1f1/Omon/${var}/gn/v20200724"
    "/g/data/oi10/replicas/CMIP6/CMIP/NIMS-KMA/KACE-1-0-G/historical/r1i1p1f1/Omon/${var}/gr/v20200130"
    "/g/data/oi10/replicas/CMIP6/CMIP/MIROC/MIROC6/historical/r1i1p1f1/Omon/${var}/gn/v20210129"
    "/g/data/oi10/replicas/CMIP6/CMIP/MIROC/MIROC-ES2L/historical/r1i1p1f2/Omon/${var}/gn/v20190823"
    "/g/data/oi10/replicas/CMIP6/CMIP/AS-RCEC/TaiESM1/historical/r1i1p1f1/Omon/${var}/gn/v20200630"
    "/g/data/oi10/replicas/CMIP6/CMIP/MOHC/UKESM1-0-LL/historical/r1i1p1f2/Omon/${var}/gn/v20190627"
    "/g/data/oi10/replicas/CMIP6/CMIP/SNU/SAM0-UNICON/historical/r1i1p1f1/Omon/${var}/gn/v20190323"
    "/g/data/oi10/replicas/CMIP6/CMIP/THU/CIESM/historical/r1i1p1f1/Omon/${var}/gn/v20200220"
    "/g/data/oi10/replicas/CMIP6/CMIP/UA/MCM-UA-1-0/historical/r1i1p1f1/Omon/${var}/gn/v20190731"
)

OUTPUT_FILES=(
#    "${var}_Omon_ACCESS-CM2_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_ACCESS-ESM1-5_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_AWI-CM-1-1-MR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_AWI-ESM-1-1-MR_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_BCC-CSM2-MR_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_BCC-ESM1_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CAMS-CSM1-0_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_CAS-ESM2-0_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_FGOALS-f3-L_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_FGOALS-g3_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CanESM5_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_IITM-ESM_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CESM2_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CESM2-WACCM_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CESM2-FV2_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CESM2-WACCM-FV2_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_CMCC-CM2-HR4_historical_1995_2014_r360x180_SH_n.nc"
#    "${var}_Omon_CMCC-CM2-SR5_historical_1995_2014_r360x180_SH_n.nc"
#    "${var}_Omon_CMCC-ESM2_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_CNRM-CM6-1_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_CNRM-CM6-1-HR_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_CNRM-ESM2-1_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_EC-Earth3_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_EC-Earth3-Veg-LR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_E3SM-1-0_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_FIO-ESM-2-0_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_GFDL-CM4_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_GFDL-ESM4_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_GISS-E2-1-HR_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_GISS-E2-1-G_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_HadGEM3-GC31-LL_historical_1995_2014_r360x180_SH_n.nc"
    "${var}_Omon_HadGEM3-GC31-MM_historical_1995_2014_r360x180_SH_n.nc"
    "${var}_Omon_INM-CM4-8_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_INM-CM5-0_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_IPSL-CM6A-LR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_KIOST-ESM_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_MPI-ESM1-2-HR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_MPI-ESM1-2-LR_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_ICON-ESM-LR_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_MRI-ESM2-0_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_NESM3_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_NorESM2-LM_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_NorESM2-MM_historical_1995_2014_r360x180_SH.nc"
#    "${var}_Omon_NorCPM1_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_KACE-1-0-G_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_MIROC6_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_MIROC-ES2L_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_TaiESM1_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_UKESM1-0-LL_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_SAM0-UNICON_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_CIESM_historical_1995_2014_r360x180_SH.nc"
    "${var}_Omon_MCM-UA-1-0_historical_1995_2014_r360x180_SH.nc"
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
        ## remapbil (bilinear) for all
        #REMAP_METHOD="remapbil"
        #run_cdo cdo $REMAP_METHOD,r360x180 "$TMP_DIR/${base%.nc}_time.nc" "$TMP_DIR/${base%.nc}_remap.nc" \
        #    || { echo "  remap failed for $base, skipping..."; continue; }

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

