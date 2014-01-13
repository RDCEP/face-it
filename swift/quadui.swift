type file;

app (file _stdout, file _stderr) quadui (file _quaduijar, file _Survey_data, file _Field_data, file _Strategy_data, string _outdir){
    java "-Xms256m" "-Xmx768m" "-jar" @_quaduijar "-cli" "-zip" "-clean" "-f" "-s" "-D" @_Survey_data " " @_Field_data @_Strategy_data _outdir stdout=@_stdout stderr=@_stderr;
}

file quaduijar<single_file_mapper; file=@arg("jar")>;

file Survey_data   <single_file_mapper; file=@arg("survey")>;
file Field_data    <single_file_mapper; file=@arg("field")>;
file Strategy_data <single_file_mapper; file=@arg("strategy")>;

string quadui_outdir = @arg("outdir");

/* quadui stdout and stderr */
file quadui_stdout_output <single_file_mapper; file=@strcat("logs/", "o_quadui.log")>;
file quadui_stderr_output <single_file_mapper; file=@strcat("logs/", "e_quadui.log")>;

/* run quadui */
(quadui_stdout_output, quadui_stderr_output) = quadui (quaduijar, Survey_data, Field_data, Strategy_data, quadui_outdir);

