@importerAdder =
  init: ->
    $('#add_import_submit').click (e) ->
      e.preventDefault()
      $.ajax api_url+"/import/new",
        type: 'POST',
        crossDomain: true,
        dataType: "json",
        data:
          "name": $('#name').val(),
          "namespace": $('#namespace').val(),
          "geo_context": $('#geo_context').val(),
          "format_definition": $('#format_definition').val()
          "url": $('#url').val()
          "description": $('#description').val()
        success: ->
          importerLoader.load_index()
        error: (jqXHR, textStatus, errorThrown) ->
          json_error jqXHR.responseText

    importerAdder.load_fd()

  build_select: (data) ->
    $('#format_definition option').remove() if $('#format_definition option')

    for obj in data
      row = obj["format_definition"]
      line = "<option value='"+row.id+"'>"+row.name+"</option>"
      $("#format_definition").append(line)
  load_fd: ->
    $.ajax api_url+"/format_definition",
      crossDomain: true,
      error: (jqXHR, textStatus, errorThrown) ->
        json_error jqXHR.responseText
      success: (data, textStatus, jqXHR) ->
        importerAdder.build_select(data)

@importerLoader =
  init: ->
    importerLoader.load_index()
  load_index: ->
    $.ajax api_url+"/import",
      crossDomain: true,
      error: (jqXHR, textStatus, errorThrown) ->
        json_error jqXHR.responseText
      success: (data, textStatus, jqXHR) ->
        importerLoader.build_table(data)
  build_table: (data) ->
    $('tr.r').remove() if $('tr.r')

    for obj in data
      row = obj["import"]
      line = "<tr class='r'>
          <td>"+row.id+"</td>
          <td>"+row.name+"</td>
          <td>"+row.namespace+"</td>
          <td>"+row.geo_context+"</td>
          <td>"+row.format_definition_id+"</td>
          <td>"+row.url+"</td>
          <td>"+row.description+"</td>
          <td class=''>
            <a href='javascript:importerLoader.run_import("+row.id+")' class='btn btn-success'>Run!</a>
            <a href='javascript:importerLoader.delete_row("+row.id+")' class='btn btn-danger'>Delete</a>
          </td>
        </tr>"
      $("table#imports").append(line)
  run_import: (id) ->
    $.ajax api_url+"/import/"+id+"/run",
      crossDomain: true,
      error: (jqXHR, textStatus, errorThrown) ->
        alert 'error'
        json_error jqXHR.responseText
      success: (data, textStatus, jqXHR) ->
        alert 'success'

  delete_row: (id) ->
    alert 'delete'
    $.ajax api_url+"/import/"+id+"/delete",
      type: 'POST',
      crossDomain: true,
      dataType: "json",
      success: ->
        importerLoader.load_index()
      error: (jqXHR, textStatus, errorThrown) ->
        json_error jqXHR.responseText

$ ->
  if location.pathname.match("/import")
    importerLoader.init()
    importerAdder.init()

