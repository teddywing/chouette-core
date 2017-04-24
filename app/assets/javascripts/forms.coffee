# IE fix
isIE = false || !!document.documentMode
isEdge = !isIE && !!window.StyleMedia

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

  if isIE || isEdge
    $('.formSubmitr').off()

@colorSelector = ->
  $('.form-group .dropdown.color_selector').each ->
    selectedStatus = $(this).children('.dropdown-toggle').children('.fa-circle')

    $(this).on 'click', "input[type='radio']", (e) ->
      selectedValue = e.currentTarget.value
      if selectedValue == ''
        $(selectedStatus).css('color', 'transparent')
      else
        $(selectedStatus).css('color', selectedValue)

$(document).on 'turbolinks:load', togglableFilter
$(document).on 'turbolinks:load', submitMover
$(document).on 'turbolinks:load', switchInput
$(document).on 'turbolinks:load', colorSelector

if isIE || isEdge
  $(document).on 'click', '.formSubmitr', (e)->
    e.preventDefault()
    target = $(this).attr('form')
    $('#' + target).submit()
