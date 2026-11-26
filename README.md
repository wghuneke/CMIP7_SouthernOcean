# CMIP7_SouthernOcean
A collaborative project to create and discuss figures for an assessment of the Southern Ocean state in CMIP7 fast-track.

**Project aims**:
1. Model biases (CMIP6 vs CMIP7: historical 1995-2014 mean)
- Showcase biases
- Classify models
- Understand biases
2. Future change (CMIP7: VL , H future scenarios)

**Overview of planned analyses**:

Tier 1: Temperature, Salinity
- SST, SSS
- MLD
- 3D T, S, density

Tier 2: Circulation
- Overturning
- Gyres
- ACC (?)
- ASC

Tier 3: Surface fluxes
- surface wind stress
- surface heat flux
- PME, runoff

**Where do I find a subset of the data on Australia's supercomputer gadi?**

CMIP6:
- CMIP6 historical:`/g/data/lg87/wgh581/CMIP6_CMIP7_Subset/CMIP6/historical/`

CMIP7: 

Note there are either concentration-driven or emissions-driven runs. Some models, e.g. ACCESS-ESM1.6 provide both, others only one of them. The emissions-driven runs have a `esm-*` prefix.
- CMIP7 historical/esm-historical: 
`/g/data/lg87/wgh581/CMIP6_CMIP7_Subset/CMIP7/historical/`, `/g/data/lg87/wgh581/CMIP6_CMIP7_Subset/CMIP7/esm-hist/`
- CMIP7 scen7-h/esm-scen7-h: `/g/data/lg87/wgh581/CMIP6_CMIP7_Subset/CMIP7/scen7-h/`, `/g/data/lg87/wgh581/CMIP6_CMIP7_Subset/CMIP7/esm-scen7-h/` 
- CMIP7 scen7-vl/esm-scen7-vl: `/g/data/lg87/wgh581/CMIP6_CMIP7_Subset/CMIP7/scen7-vl/`, `/g/data/lg87/wgh581/CMIP6_CMIP7_Subset/CMIP7/esm-scen7-vl/`

**Observational products**:
Temperature/Salinity:
- OCEAN ICE Southern Ocean Climatology, poleward from 45S: `/g/data/lg87/wgh581/CMIP6_CMIP7_Subset/Observations`
- WAO23: `/g/data/ik11/inputs/access-om3/woa23/monthly`

Use both products where possible, otherwise use preferably the OCEAN ICE product.

Mixed layer depth:
-  DeBoyer Montegut (2023) `/g/data/av17/access-nri/OM3/MLD-DeBoyerMontegut2023/mld_dr003_ref10m_v2023.nc`

**Models to include in analysis**:

Coming soon. For now, just check the files available for each variable. 
