@navpanel = ->
  $('#menu_top').each ->
    $(this).on 'click', "[data-panel='toggle']", (e) ->
      e.preventDefault()
      $(this).siblings().removeClass 'active'
      $(this).toggleClass 'active'

      target = $(this).data('target')
      $(target).siblings().removeClass 'open'
      $(target).toggleClass 'open'

$(document).on 'ready turbolinks:load', navpanel
