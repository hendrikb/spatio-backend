@importerAdder =
  init: ->
    $('#add_import_submit').click (e) ->
      e.preventDefault()
      $.ajax api_url+"/import/new",
        type: 'POST',
        crossDomain: true,
        data:
          "import":
            "name": $('#name').val(),
            "namespace": $('#namespace').val(),
            "geo_context": $('#geo_context').val(),
            "format_definition_id": $('#format_definition').val()
            "url": $('#url').val()
            "description": $('#description').val()
        success: ->
          importerLoader.load_index()
          $("#add_import_form :input").val("")
          $('#container').trigger('flashSuccess', ['Import was created'])
        error: (jqXHR, textStatus, errorThrown) ->
          json_error jqXHR.responseText

    importerAdder.load_fd()


  load_fd: ->
    $.ajax api_url+"/format_definition",
      crossDomain: true,
      error: (jqXHR, textStatus, errorThrown) ->
        json_error jqXHR.responseText
      success: (data, textStatus, jqXHR) ->
        importerAdder.build_select(data)

  build_select: (data) ->
    $('#format_definition option').remove() if $('#format_definition option')
    for obj in data
      row = obj["format_definition"]
      line = "<option value='"+row.id+"'>"+row.name+"</option>"
      $("#format_definition").append(line)

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
          <td>"+row.name+"</td>
          <td>"+row.namespace+"</td>
          <td>"+row.geo_context+"</td>
          <td>"+row.format_definition_id+"</td>
          <td>"+row.url+"</td>
          <td>"+row.description+"</td>
          <td>
            <button id='run_import_"+row.id+"' data-id='"+row.id+"' class='btn btn-success'>Run!</button>
            <button id='delete_import_"+row.id+"' data-id='"+row.id+"' class='btn btn-danger'>Delete</button>
          </td>
        </tr>"
      $("table#imports").append(line)
      $("button#run_import_"+row.id).click (e) ->
        e.preventDefault()
        importerLoader.run_import($(e.target).data("id"))
      $("button#delete_import_"+row.id).click (e) ->
        e.preventDefault()
        importerLoader.delete_import($(e.target).data("id"))


  run_import: (id) ->
    $('#run_import_'+id).attr("disabled", "disabled").text("Running...")
    $.ajax api_url+"/import/"+id+"/run",
      crossDomain: true,
      error: (jqXHR, textStatus, errorThrown) ->
        json_error jqXHR.responseText
      success: (data, textStatus, jqXHR) ->
        $('#container').trigger('flashSuccess', ['Import was scheduled.'])

  delete_import: (id) ->
    $.ajax api_url+"/import/"+id+"/delete",
      type: 'POST',
      crossDomain: true,
      success: ->
        importerLoader.load_index()
        $('#container').trigger('flashSuccess', ['Import was deleted.'])
      error: (jqXHR, textStatus, errorThrown) ->
        json_error jqXHR.responseText

$ ->
  if location.pathname.match("/import")
    importerLoader.init()
    importerAdder.init()

