@combinedTypeToggle = ->
  $('#time_table_combination_combined_type').on 'click', ->
    $(this).closest('.has_switch').siblings('.form-group').each ->
      $(this).toggleClass('hidden')

$(document).on 'turbolinks:load', combinedTypeToggle
