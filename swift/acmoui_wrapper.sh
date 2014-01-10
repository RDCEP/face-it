#!/bin/sh
set -x

#sh @_acmoui_wrapper @_acmouijar _dssatoutdir _dssat_stdout;
# eg. home/kcm92/faceit-pipeline/acmo/acmoui-1.2-SNAPSHOT-beta4.jar /home/kcm92/faceit-pipeline/FIXED_ACE_DOME/ACCESS1/4.5/END/ISHIARAdssat_outdir logs/home/kcm92/faceit-pipeline/FIXED_ACE_DOME/ACCESS1/4.5/END/ISHIARAo_dssat.log
acmouijar=$1 # home/kcm92/faceit-pipeline/acmo/acmoui-1.2-SNAPSHOT-beta4.jar
dssatoutdir=$2 # /home/kcm92/faceit-pipeline/FIXED_ACE_DOME/ACCESS1/4.5/END/ISHIARAdssat_outdir

echo $@

echo " DSSAT done, Run acmoui ..."
for i in ${dssatoutdir}/*.SNX
do
    #cp ${i}_dir/* ${dssatoutdir}
    cat ${i}_dir/Summary.OUT >> ${dssatoutdir}/Summary.OUT
done
cp $i/ACMO_meta.dat ${dssatoutdir}
java -jar $acmouijar -cli -dssat ${dssatoutdir}
