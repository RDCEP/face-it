#!/bin/sh
set -x

#sh @_dssat_wrapper @_dssatexe @_dssat_aux @_dssat_input_zip _outdir stdout=@_stdout stderr=@_stderr;
#e.g. home/kcm92/faceit-pipeline/DSCSM045.EXE home/kcm92/faceit-pipeline/dssat_aux.tgz home/kcm92/faceit-pipeline/FIXED_ACE_DOME/ACCESS1/4.5/END/ISHIARA_outdir/DSSAT/dssat_input.zip /home/kcm92/faceit-pipeline/FIXED_ACE_DOME/ACCESS1/4.5/END/ISHIARAdssat_outdir

dssatexe=$1 # home/kcm92/faceit-pipeline/DSCSM045.EXE
dssat_aux=$2 # home/kcm92/faceit-pipeline/dssat_aux.tgz
dssat_input_zip=$3 # home/kcm92/faceit-pipeline/FIXED_ACE_DOME/ACCESS1/4.5/END/ISHIARA_outdir/DSSAT/DSSAT_Input.zip
outdir=$4 # /home/kcm92/faceit-pipeline/FIXED_ACE_DOME/ACCESS1/4.5/END/ISHIARAdssat_outdir

echo $@

mkdir -p $outdir
tar -C $outdir -zxf $dssat_aux
cp $dssat_input_zip $outdir
cp $dssatexe $outdir
cd $outdir && unzip $(basename $dssat_input_zip)
mv dssat_aux/* .
ls
#Run DSSAT here
for i in *.SNX
do
    ./$(basename $dssatexe) A $i
    rm -f SoilOrg.OUT PlantGro.OUT OVERVIEW.OUT LUN.LST DSSAT45.INP DSSAT45.INH
    mkdir -p ${i}_dir
    mv *.OUT ${i}_dir
done

