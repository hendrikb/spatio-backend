build_table = (data) ->
  $('tr.r').remove() if $('tr.r')

  for obj in data
    row = obj["format_definition"]
    line = "<tr class='r'><td>"+row.id+"</td><td>"+row.name+"</td><td>"+row.importer_class+"</td><td>"+row.description+"</rd><td><a href='javascript: delete_row("+row.id+")' class='btn btn-danger'>Delete</a></td></tr>"
    $("table").append(line)

@json_error = (json_error_string) ->
    error_obj = JSON.parse json_error_string
    msg = "The following error(s) occured:\n"
    for error in error_obj.errors
      msg += "- "+error["error"]+"\n"
    alert msg

@delete_row = (id) ->
  $.ajax api_url+"/format_definition/"+id+"/delete",
    type: 'POST',
    crossDomain: true,
    dataType: "json",
    success: ->
      load_index()
    error: (jqXHR, textStatus, errorThrown) ->
      json_error jqXHR.responseText

load_index = () ->
  $.ajax api_url+"/format_definition",
    crossDomain: true,
    error: (jqXHR, textStatus, errorThrown) ->
      json_error jqXHR.responseText
    success: (data, textStatus, jqXHR) ->
      build_table data


$(document).ready ->
  load_index()


  $('#format_definition_form button').click (e) ->
    e.preventDefault()
    $.ajax api_url+"/format_definition/new",
      type: 'POST',
      crossDomain: true,
      dataType: "json",
      data:
        "name": $('#name').val(),
        "importer_class": $('#importer_class').val(),
        "importer_parameters": $('#importer_parameters').val(),
        "description": $('#description').val()
      success: ->
        load_index()
      error: (jqXHR, textStatus, errorThrown) ->
        json_error jqXHR.responseText
