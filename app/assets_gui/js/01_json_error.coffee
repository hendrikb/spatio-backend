@json_error = (json_error_string) ->
    try
      error_obj = JSON.parse json_error_string
    catch error
      msg = "A general Error occured: #{error.name}, #{error.message}"
      $('#container').trigger('flashError', [msg])
      return

    msg = "The following error(s) occured: <br />"
    for error in error_obj.errors
      msg += "- " + error + "<br /> "

    $('#container').trigger('flashError', [msg])

