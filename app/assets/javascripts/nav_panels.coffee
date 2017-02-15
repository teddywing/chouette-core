$(document).on 'ready page:load', ->
  $('#menu_top [data-panel="toggle"]').on 'click', (e) ->
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
