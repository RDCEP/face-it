#! /bin/bash
set -x
#set -e

quaduijar="./exec/quadui-1.2.1-SNAPSHOT-Beta14.jar"
acmouijar="./exec/acmoui-1.2-SNAPSHOT-beta4.jar"

datadir="./data/FIXED_ACE_DOME"

#for zipfile in `find faceit-eastafrica-data -iname "Field*.zip"`
for zipfile in $(find $datadir -iname "Field*.zip")
do 
    dirname=`dirname $zipfile`

    surveydata="$dirname/Survey_data_import.zip"
    linkagedata="$dirname/Survey_data_import_Linkage.aceb"
    fielddata="$dirname/Field_Overlay.zip"
    strategydata="$dirname/Seasonal_strategy.zip"
    outdir="${dirname}_outdir"
    
    echo "Starting ..."
    sleep 1
    
    echo " Run quadui ... "
    time -p java -Xms256m -Xmx768m -jar $quaduijar -cli -zip -clean -f -s -D $surveydata ' '  $fielddata $strategydata $outdir
    #time -p java -Xms256m -Xmx768m -jar $quaduijar -cli -zip -clean -f -s -D $surveydata $linkagedata $fielddata $strategydata $outdir
    
    #Copy DSSAT Auxiliary file bundle to outdir/DSSAT
    cp ./exec/dssat_aux.tgz $outdir/DSSAT
    
    #unzip quadoutdir/DSSAT and the DSSAT_Input.zip
    cd $outdir/DSSAT
    unzip DSSAT_Input.zip

    ##untar the auxiliary package here and move all files in DSSAT dir
    tar zxf dssat_aux.tgz && mv dssat_aux/* .
     
    echo "quadui done,  run DSSAT ... "
    #sleep 1
    #
    for i in *.SNX
    do
      ./DSCSM045.EXE A $i
      rm -f SoilOrg.OUT PlantGro.OUT OVERVIEW.OUT LUN.LST DSSAT45.INP DSSAT45.INH
      mkdir -p ${i}_dir
      mv *.OUT ${i}_dir
    done 
    #
    cd -
    #
    echo " DSSAT done, Run acmoui ..."
    for i in ${outdir}/DSSAT/*.SNX
    do
        cat ${i}_dir/Summary.OUT >> ${outdir}/DSSAT/Summary.OUT
    done
    java -jar $acmouijar -cli -dssat ${outdir}/DSSAT
    #
    echo "Done. Check out results in $outdir/DSSAT"
done

