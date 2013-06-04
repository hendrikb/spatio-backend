@formatDefinition =
  init: ->
    formatDefinition.load_index()
    formatDefinition.load_reader()

    $('#format_definition_form button').click (e) ->
      e.preventDefault()
      $.ajax api_url+"/format_definition/new",
        type: 'POST',
        crossDomain: true,
        data:
          "name": $('#name').val(),
          "importer_class": $('#importer_class').val(),
          "importer_parameters": $('#importer_parameters').val(),
          "description": $('#description').val()
        success: ->
          formatDefinition.load_index()
          $("#format_definition_form :input").val("")
          $('#container').trigger('flashSuccess', ['FormatDefinition was created.'])
        error: (jqXHR, textStatus, errorThrown) ->
          json_error jqXHR.responseText

  load_index: ->
    $.ajax api_url+"/format_definition",
      crossDomain: true,
      error: (jqXHR, textStatus, errorThrown) ->
        json_error jqXHR.responseText
      success: (data, textStatus, jqXHR) ->
        formatDefinition.build_table data

  build_table:  (data) ->
    $('tr.r').remove() if $('tr.r')

    for obj in data
      row = obj["format_definition"]
      line = "<tr class='r'>
                <td>"+row.name+"</td>
                <td>"+row.importer_class+"</td>
                <td>"+row.description+"</rd>
                <td><button id='delete_row_"+row.id+"' data-id='"+row.id+"' class='btn btn-danger'>Delete</button></td>
              </tr>"
      $("table#format_definitions").append(line)
      $("button#delete_row_"+row.id).click (e) ->
        e.preventDefault()
        formatDefinition.delete_row($(e.target).data("id"))

  delete_row: (id) ->
    $.ajax api_url+"/format_definition/"+id+"/delete",
      type: 'POST',
      crossDomain: true,
      success: ->
        formatDefinition.load_index()
        $('#container').trigger('flashSuccess', ['FormatDefinition was deleted.'])
      error: (jqXHR, textStatus, errorThrown) ->
        json_error jqXHR.responseText

  load_reader: ->
    $.ajax api_url+"/reader",
      crossDomain: true,
      error: (jqXHR, textStatus, errorThrown) ->
        json_error jqXHR.responseText
      success: (data, textStatus, jqXHR) ->
        formatDefinition.build_select(data)

  build_select: (data) ->
    $('#importer_class option').remove() if $('#importer_class option')
    for obj in data
      line = "<option value='"+obj+"'>"+obj+"</option>"
      $("#importer_class").append(line)

$ ->
  if location.pathname.match("/format_definition")
    formatDefinition.init()
