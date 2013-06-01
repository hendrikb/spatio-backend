container =
  init: ->
    @container = $('#container')
    @close_button = '<button type="button" class="close" data-dismiss="alert">&times;</button>'

    @container.on 'flashSuccess', (event, message) ->
      container.flashSuccess(message)

    @container.on 'flashError', (event, message) ->
      container.flashError(message)

  flashSuccess: (message) ->
    msg = @close_button + message
    @addFlashStatusDiv()
    $('#flash_status').addClass('alert-success').removeClass('alert-error').html(msg).show()

  flashError: (message) ->
    msg = @close_button + message
    @addFlashStatusDiv()
    $('#flash_status').addClass('alert-error').removeClass('alert-success').html(msg).show()

  addFlashStatusDiv:  ->
    $('#flash').html('<div class="alert" id="flash_status"></div>')

$ ->
  container.init()
