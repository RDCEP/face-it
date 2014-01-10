/*
Swift app definitions for Face-it Agmip pipeline
*/

app (file _stdout, file _stderr) quadui (file _quaduijar, file _Survey_data, file _Field_data, file _Strategy_data, string _outdir){
    java "-Xms256m" "-Xmx768m" "-jar" @_quaduijar "-cli" "-zip" "-clean" "-f" "-s" "-D" @_Survey_data " " @_Field_data @_Strategy_data _outdir stdout=@_stdout stderr=@_stderr;
}

app (file _stdout, file _stderr) dssat (file _dssat_wrapper, file _dssatexe, file _dssat_aux, file _dssat_input_zip, string _outdir, file _quadui_stdout){
    sh @_dssat_wrapper @_dssatexe @_dssat_aux @_dssat_input_zip _outdir stdout=@_stdout stderr=@_stderr;
}

app (file _stdout, file _stderr) acmoui (file _acmoui_wrapper, file _acmouijar, string _dssatoutdir, file _dssat_stdout){
    sh @_acmoui_wrapper @_acmouijar _dssatoutdir @_dssat_stdout stdout=@_stdout stderr=@_stderr;
}


