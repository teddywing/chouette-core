@widget_bar = ->
  $('#widget_bar').each ->
    $(this).on 'click', '.toggleWidgets', (e) ->
      $(this).parent().toggleClass 'open'

$(document).on 'ready turbolinks:load', widget_bar
