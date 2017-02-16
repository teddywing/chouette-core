@togglableFilter = ->
  $('.form-group.togglable').on 'click', ->
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
