@select_2 = ->
  $("[data-select2ed='true']").each(->
    $(this).select2
      theme: 'bootstrap'
      language: 'fr'
      placeholder: target.data('select2ed-placeholder')
  )

$(document).on 'ready page:load', select_2
