@togglableFilter = ->
  $('.form-group.togglable').on 'click', ->
    $(this).siblings().removeClass 'open'
    $(this).toggleClass 'open'

$(document).on 'ready page:load', togglableFilter
