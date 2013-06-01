@json_error = (json_error_string) ->
    error_obj = JSON.parse json_error_string
    msg = "The following error(s) occured: <br />"
    for error in error_obj.errors
      msg += "- " + error + "<br /> "
    $('#container').trigger('flashError', [msg])

