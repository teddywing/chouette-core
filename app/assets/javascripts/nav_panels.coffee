@navpanel = ->
  $('#menu_top').each ->
    $(this).on 'click', "[data-panel='toggle']", (e) ->
      e.preventDefault()
      $(this).siblings().removeClass 'active'
      $(this).toggleClass 'active'

      target = $(this).data('target')
      $(target).siblings().removeClass 'open'
      $(target).toggleClass 'open'

    $(document).on 'scroll', ->
      $("[data-panel='toggle']").each ->
        $(this).removeClass 'active'
        $($(this).data('target')).removeClass 'open'

$(document).on 'ready page:load', navpanel
