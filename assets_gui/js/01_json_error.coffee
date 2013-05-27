@json_error = (json_error_string) ->
    error_obj = JSON.parse json_error_string
    msg = "The following error(s) occured:\n"
    for error in error_obj.errors
      msg += "- "+error["error"]+"\n"
    alert msg
