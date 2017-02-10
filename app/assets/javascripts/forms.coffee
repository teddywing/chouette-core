@togglableFilter = ->
  $('.form-group.togglable').on 'click', ->
    $(this).siblings().removeClass 'open'
    $(this).toggleClass 'open'

@submitMover = ->
  $('.formSubmitr').appendTo('.page-action')


$(document).on 'ready page:load', togglableFilter
$(document).on 'ready page:load', submitMover
