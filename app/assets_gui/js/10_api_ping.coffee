@apiPinger =
  pingCycle: ->
    api_status = $('#api_status')
    api_status.html("API: polling").removeClass("label-success label-important")
    $.get api_url+"/ping", ->
      api_status.html("API: online").addClass("label-success")
    .fail ->
      api_status.html("API: offline").addClass("label-important")

$ ->
  setInterval(apiPinger.pingCycle,50000000)
