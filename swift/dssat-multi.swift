type file;

type Data{
    string Survey_data;
    string Field_data;
    string Strategy_data;
    string quadui_outdir;
    string dssat_outdir;
}

app (file _stdout, file _stderr) dssat (file _dssat_wrapper, file _dssatexe, file _dssat_aux, file _dssat_input_zip, string _outdir){
    sh @_dssat_wrapper @_dssatexe @_dssat_aux @_dssat_input_zip _outdir stdout=@_stdout stderr=@_stderr;
}

file dssat_exe<"/home/kcm92/faceit-gitrepo/exec/dssat_aux/DSCSM045.EXE">;
file dssat_wrapper<"/home/kcm92/faceit-gitrepo/swift/dssat_wrapper.sh">;
file dssat_aux<"/home/kcm92/faceit-gitrepo/exec/dssat_aux.tgz">;

Data d[] = readData(@arg("data"));

foreach region, i in d{
    /* input for dssat */
    file dssat_inputzip <single_file_mapper; file=@strcat(region.quadui_outdir, "/DSSAT/DSSAT_Input.zip")>;
    string dssat_outdir = region.dssat_outdir;

    /* dssat stdout and stderr */
    file dssat_stdout_output <single_file_mapper; file=@strcat("logs/", region.quadui_outdir, "o_dssat.log")>;
    file dssat_stderr_output <single_file_mapper; file=@strcat("logs/", region.quadui_outdir, "e_dssat.log")>; 

    /* run dssat
       Commandline of DSSAT: $DSSATHOME/DSCSM045.EXE b DSSBatch.v45 DSCSM046.CTR
    */
    (dssat_stdout_output, dssat_stderr_output) = dssat (dssat_wrapper, dssat_exe, dssat_aux, dssat_inputzip, dssat_outdir);    
}

