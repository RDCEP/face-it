#!/bin/sh
set -x

#sh @_dssat_wrapper @_dssatexe @_dssat_aux @_dssat_input_zip _outdir stdout=@_stdout stderr=@_stderr;

dssatexe=$1 
dssat_aux=$2 
dssat_input_zip=$3 
outdir=$4 

echo $@

mkdir -p $outdir
tar -C $outdir -zxf $dssat_aux
cp $dssat_input_zip $outdir
cd $outdir && unzip $(basename $dssat_input_zip)
#for i in $(\ls $dssat_aux); do ln -s $dssat_aux/$i $i; done
mv dssat_aux/* .
#Run DSSAT here
#Commandline of DSSAT: $DSSATHOME/DSCSM045.EXE b DSSBatch.v45 DSCSM046.CT
./$(basename $dssatexe) b DSSBatch.v45 DSCSM046.CT
rm -f SoilOrg.OUT PlantGro.OUT OVERVIEW.OUT LUN.LST DSSAT45.INP DSSAT45.INH

