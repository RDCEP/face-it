import json

galaxywf='{ "a_galaxy_workflow": "true", "annotation": "anannotation", "format-version": "0.1", "name": "MyFirst", "steps": { "0": { "annotation": "", "id": 0, "input_connections": {}, "inputs": [ { "description": "", "name": "Input Dataset" } ], "name": "Input dataset", "outputs": [], "position": { "left": 130, "top": 248.5 }, "tool_errors": null, "tool_id": null, "tool_state": "{\"name\": \"Input Dataset\"}", "tool_version": null, "type": "data_input", "user_outputs": [] }, "1": { "annotation": "", "id": 1, "input_connections": { "data": { "id": 0, "output_name": "output" } }, "inputs": [], "name": "Swift catsn", "outputs": [ { "name": "log_file", "type": "txt" }, { "name": "html_file", "type": "html" } ], "position": { "left": 415, "top": 209.5 }, "post_job_actions": {}, "tool_errors": null, "tool_id": "catsn", "tool_state": "{\"__page__\": 0, \"__rerun_remap_job_id__\": null, \"data\": \"null\", \"site\": \"\\\"localhost\\\"\", \"n\": \"\\\"100\\\"\"}", "tool_version": "1.0.0", "type": "tool", "user_outputs": [] } }'
#galaxy_string = json.dumps(galaxywf)

simplejson = [ { 'a':'A', 'b':(2, 4), 'c':3.0 } ]
simple_string = json.dumps(simplejson)

print simple_string
