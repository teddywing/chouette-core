@select_2 = ->
  $("[data-select2ed='true']").each ->
    target = $(this)
    target.select2
      theme: 'bootstrap'
      language: 'fr'
      placeholder: target.data('select2ed-placeholder')
      allowClear: true

  $('select.form-control.tags').each ->
    target = $(this)
    target.select2
      theme: 'bootstrap'
      language: 'fr'
      allowClear: true
      tags: true


$(document).on 'ready page:load', select_2
