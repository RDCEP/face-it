#! /bin/bash
set -x
#set -e

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#quaduijar="./exec/quadui-1.2.1-SNAPSHOT-Beta14.jar"
quaduijar="$DIR/exec/quadui-1.2.1-SNAPSHOT-jar-with-dependencies.jar"
acmouijar="$DIR/exec/acmoui-1.2-SNAPSHOT-beta4.jar"

datadir="$DIR/data/FIXED_ACE_DOME"

DSSATHOME="$DIR/exec/dssat_aux"
#for zipfile in `find faceit-eastafrica-data -iname "Field*.zip"`
for zipfile in $(find $datadir -iname "Field*.zip")
do 
    curdir=`dirname $zipfile`

    surveydata="$curdir/Survey_data_import.zip"
    linkagedata="$curdir/Survey_data_import_Linkage.aceb"
    fielddata="$curdir/Field_Overlay.zip"
    strategydata="$curdir/Seasonal_strategy.zip"
    outdir="${curdir}_outdir"
    
    echo "Starting ..."
    sleep 1
    
    echo " Run quadui ... "
    #Example call to quadui
    #java -Xms256m -Xmx768m -jar ./exec/quadui-1.2.1-SNAPSHOT-jar-with-dependencies.jar -cli -clean -f -s -D
    # ./data/FIXED_ACE_DOME/ACCESS1/4.5/END/EMBU/Survey_data_import.zip ' ' ./data/FIXED_ACE_DOME/ACCESS1/4.5/END/EMBU/Field_Overlay.zip
    # ./data/FIXED_ACE_DOME/ACCESS1/4.5/END/EMBU/Seasonal_strategy.zip ./data/FIXED_ACE_DOME/ACCESS1/4.5/END/EMBU_outdir
    
    time -p java -Xms256m -Xmx768m -jar $quaduijar -cli -clean -f -s -D $surveydata ' '  $fielddata $strategydata $outdir

    
    cd $outdir/DSSAT && for i in $(\ls $DSSATHOME); do ln -s $DSSATHOME/$i $i; done 

    echo "quadui done,  run DSSAT ... "
    #sleep 1
    #
    $DSSATHOME/DSCSM045.EXE b DSSBatch.v45 DSCSM046.CTR
    #
    cd -
    #
    echo " DSSAT done, Run acmoui ..."
    java -jar $acmouijar -cli -dssat ${outdir}/DSSAT
    #
    echo "Done. Check out results in $outdir/DSSAT"
done

