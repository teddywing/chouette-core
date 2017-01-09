@mainmenu = ->
  $('#main_nav').each ->
    $(this).on 'click', '.toggleMenu', (e) ->
      $(this).parent().toggleClass 'open'

$(document).on 'ready turbolinks:load', mainmenu
