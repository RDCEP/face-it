type file;

/* Swift app definitions for Face-it Agmip pipeline */

app (file _stdout, file _stderr) quadui (file _quaduijar, file _Survey_data, file _Field_data, file _Strategy_data, string _outdir){
    java "-Xms256m" "-Xmx768m" "-jar" @_quaduijar "-cli" "-zip" "-clean" "-f" "-s" "-D" @_Survey_data " " @_Field_data @_Strategy_data _outdir stdout=@_stdout stderr=@_stderr;
}

app (file _stdout, file _stderr) dssat (file _dssat_wrapper, file _dssatexe, file _dssat_aux, file _dssat_input_zip, string _outdir, file _quadui_stdout){
    sh @_dssat_wrapper @_dssatexe @_dssat_aux @_dssat_input_zip _outdir stdout=@_stdout stderr=@_stderr;
}

app (file _stdout, file _stderr) acmoui (file _acmoui_wrapper, file _acmouijar, string _dssatoutdir, file _dssat_stdout){
    sh @_acmoui_wrapper @_acmouijar _dssatoutdir @_dssat_stdout stdout=@_stdout stderr=@_stderr;
}

/* Data definitions for the Face-it AgMIP pipeline */

file quaduijar<"../exec/quadui-1.2.1-SNAPSHOT-Beta13.jar">;
file acmouijar<"../exec/acmoui-1.2-SNAPSHOT-beta4.jar">;

file dssat_exe<"./DSCSM045.EXE">;
file dssat_wrapper<"./dssat_wrapper.sh">;
file dssat_aux<"./dssat_aux.tgz">;
file acmoui_wrapper<"./acmoui_wrapper.sh">;

/*string regions[] = readData("regions.txt");*/
string regions[] = readData("regions-midway.txt");

foreach region, i in regions{
    
    /* Input files */
    file Survey_data  <single_file_mapper; file=@strcat(regions[i], "/Survey_data_import.zip")>;
    file Field_data   <single_file_mapper; file=@strcat(regions[i], "/Field_Overlay.zip")>;
    file Strategy_data<single_file_mapper; file=@strcat(regions[i], "/Seasonal_strategy.zip")>;
    
    string quadui_outdir = @strcat(regions[i], "_outdir");

    /* quadui stdout and stderr */
    file quadui_stdout_output <single_file_mapper; file=@strcat("logs/", regions[i], "o_quadui.log")>;
    file quadui_stderr_output <single_file_mapper; file=@strcat("logs/", regions[i], "e_quadui.log")>; 
    
    /* run quadui */
    (quadui_stdout_output, quadui_stderr_output) = quadui (quaduijar, Survey_data, Field_data, Strategy_data, quadui_outdir);
    
    /* input for dssat */
    file dssat_inputzip <single_file_mapper; file=@strcat(quadui_outdir, "/DSSAT/DSSAT_Input.zip")>;
    string dssat_outdir = @strcat(regions[i], "dssat_outdir");

    /* dssat stdout and stderr */
    file dssat_stdout_output <single_file_mapper; file=@strcat("logs/", regions[i], "o_dssat.log")>;
    file dssat_stderr_output <single_file_mapper; file=@strcat("logs/", regions[i], "e_dssat.log")>; 

    /* run dssat */
    (dssat_stdout_output, dssat_stderr_output) = dssat (dssat_wrapper, dssat_exe, dssat_aux, dssat_inputzip, dssat_outdir, quadui_stdout_output);    
    
    /* acmoui stdout and stderr */
    file acmoui_stdout_output <single_file_mapper; file=@strcat("logs/", regions[i], "o_acmoui.log")>;
    file acmoui_stderr_output <single_file_mapper; file=@strcat("logs/", regions[i], "e_acmoui.log")>; 

    /* run acmoui */
    (acmoui_stdout_output, acmoui_stderr_output) = acmoui (acmoui_wrapper, acmouijar, dssat_outdir, dssat_stdout_output); 
}

