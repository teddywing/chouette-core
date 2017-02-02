@navpanel = ->
  $('#menu_top').each ->
    $(this).on 'click', "[data-panel='toggle']", (e) ->
      e.preventDefault()
      console.log 'clicked'
      $(this).siblings().removeClass 'active'
      $(this).toggleClass 'active'

      target = $(this).data('target')
      $(target).siblings().removeClass 'open'
      $(target).toggleClass 'open'

$(document).on 'ready page:load', navpanel
