/* $Id$ */
/* $URL$ */
/* Read-in the quarterly OPM data */

/* raw data files are in each ZIP file */
/* they have to be transformed into UNIX format */
/* formats will have the same name as the input file, minus the DT */

%include "config.sas"/source2;


%macro loop(year,start=1,end=4,layout=csv);
%do q = &start. %to &end.;
%readin_data(suffix=post-2016/,year=&year.,quarter=&q.,infmtlib=OPMFMT,outputs=QUARTRLY,layout=&layout.);
%end;
%mend;

%loop(2015,layout=csv3,start=3);
%loop(2016,layout=csv3);
%loop(2017,layout=csv3);
%loop(2018,layout=csv3,end=2);


