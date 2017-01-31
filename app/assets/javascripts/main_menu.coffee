@mainmenu = ->
  $('#main_nav').each ->
    $(this).on 'click', '.openMenu', (e) ->
      $(this).parent().addClass 'open'

    $(this).on 'click', '.closeMenu', (e) ->
      console.log('pouet')
      $(this).closest('.nav-menu').removeClass 'open'

$(document).on 'ready turbolinks:load', mainmenu
