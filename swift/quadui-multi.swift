/*
swift -tc.file tc -sites.file sites.local.xml -config cf quadui.swift -survey=/pathof/Survey_data_import.zip -field=/pathof/Field_Overlay.zip -strategy=/pathof/Seasonal_strategy.zip -outdir=/pathto/outdir -jar=/pathof/quadui-1.2.1-SNAPSHOT-Beta13.jar
*/

type file;

type Data{
    string Survey_data;
    string Field_data;
    string Strategy_data;
    string quadui_outdir;
    string dssat_outdir;
}

app (file _stdout, file _stderr) quadui (file _quaduijar, file _Survey_data, file _Field_data, file _Strategy_data, string _outdir){
    java "-Xms256m" "-Xmx768m" "-jar" @_quaduijar "-cli" "-zip" "-clean" "-f" "-s" "-D" @_Survey_data " " @_Field_data @_Strategy_data _outdir stdout=@_stdout stderr=@_stderr;
}

file quaduijar<single_file_mapper; file=@arg("jar")>;

/*
file Survey_data   <single_file_mapper; file=@arg("survey")>;
file Field_data    <single_file_mapper; file=@arg("field")>;
file Strategy_data <single_file_mapper; file=@arg("strategy")>;
string quadui_outdir = @arg("outdir");
*/

Data d[] = readData(@arg("data"));

/* run quadui */
foreach ditem in d{
    /* quadui stdout and stderr */
    file quadui_stdout_output <single_file_mapper; file=@strcat("logs/", ditem.quadui_outdir, "o_quadui.log")>;
    file quadui_stderr_output <single_file_mapper; file=@strcat("logs/", ditem.quadui_outdir, "e_quadui.log")>;
    file Survey_data   <single_file_mapper; file=ditem.Survey_data>;
    file Field_data    <single_file_mapper; file=ditem.Field_data>;
    file Strategy_data <single_file_mapper; file=ditem.Strategy_data>;

    /*(quadui_stdout_output, quadui_stderr_output) = quadui (quaduijar, Survey_data, Field_data, Strategy_data, quadui_outdir);*/
    (quadui_stdout_output, quadui_stderr_output) = quadui (quaduijar, Survey_data, Field_data, Strategy_data, ditem.quadui_outdir);
#tracef("Employee %s", ditem.Survey_data);
}
