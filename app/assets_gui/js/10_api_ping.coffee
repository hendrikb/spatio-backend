@apiPinger =
  pingCycle: ->
    api_status = $('#api_status')
    api_status.html("API: polling").removeClass("label-success label-important")
    $.ajax api_url+"/ping",
      crossDomain: true,
      success: ->
        api_status.html("API: online").addClass("label-success")
      error: ->
        api_status.html("API: offline").addClass("label-important")

$ ->
  setInterval(apiPinger.pingCycle,5000)
