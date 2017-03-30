@togglableFilter = ->
  $('.form-filter').on 'click', '.form-group.togglable', (e)->
    if $(e.target).hasClass('togglable') || $(e.target).parent().hasClass('togglable')
      $(this).siblings().removeClass 'open'
      $(this).toggleClass 'open'

@switchInput = ->
  $('.form-group.has_switch').each ->
    labelCont = $(this).find('.switch-label')

    if labelCont.text() == ''
      labelCont.text(labelCont.data('uncheckedvalue'))

    $(this).on 'click', "input[type='checkbox']", ->
      if labelCont.text() == labelCont.data('checkedvalue')
        labelCont.text(labelCont.data('uncheckedvalue'))
      else
        labelCont.text(labelCont.data('checkedvalue'))

@submitMover = ->
  if $('.page-action').children('.formSubmitr').length > 0
    $('.page-action').children('.formSubmitr').remove()

  $('.formSubmitr').appendTo('.page-action')

  # IE fix
  isIE = false || !!document.documentMode
  isEdge = !isIE && !!window.StyleMedia

  if isIE || isEdge
    $('.formSubmitr').off()
    $(document).on 'click', '.formSubmitr', (e)->
      e.preventDefault()
      target = $(this).attr('form')
      $('#' + target).submit()

$(document).on 'ready page:load', togglableFilter
$(document).on 'ready page:load', submitMover
$(document).on 'ready page:load', switchInput
