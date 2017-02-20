@togglableFilter = ->
  $('.form-filter').on 'click', '.form-group.togglable', (e)->
    if $(e.target).hasClass('togglable') || $(e.target).parent().hasClass('togglable')
      $(this).siblings().removeClass 'open'
      $(this).toggleClass 'open'

@submitMover = ->
  $('.formSubmitr').appendTo('.page-action')

  # IE fix
  isIE = false || !!document.documentMode
  isEdge = !isIE && !!window.StyleMedia

  if isIE || isEdge
    $('.formSubmitr').each ->
      target = $(this).attr('form')

      $(this).on 'click', ->
        $('#' + target).submit()

$(document).on 'ready page:load', togglableFilter
$(document).on 'ready page:load', submitMover
