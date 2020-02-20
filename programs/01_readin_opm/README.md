# Reading in raw OPM data

This part of the process is time- and compute-intensive, since many data files need to be downloaded. In our case, we leverage the internal data archives of LDI, where this has already happened. The programs here are for reference.

## Inputs

Raw OPM data downloaded from opm.gov

## Outputs

Quarterly, then concatenated time series data

```
%let opmout=../../clean/opm;

libname outputs "&opmout./extra";
```

Locations are configured in config.sas, and are specific to ECCO at Cornell University. Last run on 2020-02-20. Note that there are two differnt public use time series for OPM, as OPM removed gender information after 2016.
