type file;

type Data{
    string Survey_data;
    string Field_data;
    string Strategy_data;
    string quadui_outdir;
    string dssat_outdir;
}

app (file _stdout, file _stderr) acmoui (file _acmoui_wrapper, file _acmouijar, string _dssatoutdir){
    sh @_acmoui_wrapper @_acmouijar _dssatoutdir stdout=@_stdout stderr=@_stderr;
}

/* Data definitions for the Face-it AgMIP pipeline */
file acmouijar<"./acmoui-1.2-SNAPSHOT-beta4.jar">;
file acmoui_wrapper<"./acmoui_wrapper.sh">;

Data d[] = readData(@arg("data"));

foreach region, i in d{
    /* acmoui stdout and stderr */
    file acmoui_stdout_output <single_file_mapper; file=@strcat("logs/", region.quadui_outdir, "o_acmoui.log")>;
    file acmoui_stderr_output <single_file_mapper; file=@strcat("logs/", region.quadui_outdir, "e_acmoui.log")>; 

    string dssat_outdir = region.dssat_outdir;
    /* run acmoui */
    (acmoui_stdout_output, acmoui_stderr_output) = acmoui (acmoui_wrapper, acmouijar, dssat_outdir); 
}

