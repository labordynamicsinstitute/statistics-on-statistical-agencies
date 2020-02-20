#!/bin/bash
# Prepare OPM download
# The download requires a browser, so we pre-process a snapshot of the download page
DATA=../../raw/opm
DATE=20190430
INFILE=opm${DATE}.html
OUTCSV=$DATA/SRC_${DATE}.csv
OUTSCRIPT=_tmp.sh
BASEURL=https://www.opm.gov

# Create the CSV
# First, Employment
grep -E "Employment Cube|zip" $INFILE  |\
   grep -A 1 "Employment Cube" |\
   grep zip |\
   sed "s+<a href='+$BASEURL+" |\
   sed "s+'><img src='/img/global/icoZip.gif' alt=\"Download File\" border=\"0\" /></a>++" |\
   tr -d '\r' |\
   awk ' { print NR, $1  ",Employment" } ' > _tmp.csv
grep -E "Employment Cube|zip" $INFILE  |\
   grep -A 1 "Employment Cube" |\
   grep -B 1 zip |\
   grep "Employment" |\
   sed 's+<td valign="top">FedScope Employment Cube (++' |\
   sed 's+)</td>++' | sed 's/ //g' |\
   sed 's+September+Sept+' |\
   sed 's+June+Jun+' |\
   sed 's+March+Mar+'|\
   sed 's+December+Dec+' |\
   awk ' { print NR, $1 } ' |\
   join -j 1 _tmp.csv - |\
   awk ' OFS="," { print $2,$3 } ' > _tmp2.csv

mv _tmp2.csv _tmp.csv

# Separations and Accessions have a new cumulative file
echo "$BASEURL/Data/Files/534/1c4b591f-c14e-4317-afb8-208bfc249688.zip,sep,2011-fy2017" >> _tmp.csv
echo "$BASEURL/Data/Files/532/9b2a885a-336c-4a12-9239-2b1c99209a6f.zip,sep,2005-fy2010" >> _tmp.csv
echo "$BASEURL/Data/Files/533/300c70ba-9803-4ec5-ad96-0eea3fd1af61.zip,acc,2011-fy2017" >> _tmp.csv
echo "$BASEURL/Data/Files/531/eff30d89-d539-4370-b93e-f034282d53b2.zip,acc,2005-fy2010" >> _tmp.csv

cp _tmp.csv $OUTCSV

# now process the file
cat $OUTCSV | awk -F, ' { print "firefox --new-window " $1 }' > $OUTSCRIPT

sed 's/,sep,/,separations_fy,/; s/,acc,/,accessions_fy,/; s/,Employment,/,Employment_,/' $OUTCSV |\
awk -F, ' { print "arg=" $1 ";mv $(basename $arg) FS_" $2 $3 ".zip" } '  |\
tr -d '\r' > rename$OUTSCRIPT 

# now execute it
#. _tmp.sh 
