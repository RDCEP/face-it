type file;

type Data{
    string Survey_data;
    string Field_data;
    string Strategy_data;
    string quadui_outdir;
}

app (file _stdout, file _stderr) dssat (file _dssat_wrapper, file _dssatexe, file _dssat_aux, file _dssat_input_zip, string _outdir){
    sh @_dssat_wrapper @_dssatexe @_dssat_aux @_dssat_input_zip _outdir stdout=@_stdout stderr=@_stderr;
}

file dssat_exe<"./DSCSM045.EXE">;
file dssat_wrapper<"./dssat_wrapper.sh">;
file dssat_aux<"./dssat_aux.tgz">;

Data d[] = readData(@arg("data"));

foreach region, i in d{
    /* input for dssat */
    file dssat_inputzip <single_file_mapper; file=@strcat(region.quadui_outdir, "/DSSAT/DSSAT_Input.zip")>;
    string dssat_outdir = @strcat(region.quadui_outdir, "/dssat_outdir");

    /* dssat stdout and stderr */
    file dssat_stdout_output <single_file_mapper; file=@strcat("logs/", region.quadui_outdir, "o_dssat.log")>;
    file dssat_stderr_output <single_file_mapper; file=@strcat("logs/", region.quadui_outdir, "e_dssat.log")>; 

    /* run dssat */
    (dssat_stdout_output, dssat_stderr_output) = dssat (dssat_wrapper, dssat_exe, dssat_aux, dssat_inputzip, dssat_outdir);    
}

