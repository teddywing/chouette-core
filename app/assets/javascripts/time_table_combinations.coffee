$(document).on("change", '#time_table_combination_combined_type', (e) ->
  el    = $("#time_table_combination_#{$(this).val()}_id")
  other = $(".tt_combination_target:not(##{el.attr('id')})")

  if el.length
    el.prop('disabled', false).parents('.form-group').removeClass('hidden').show()
  other.prop('disabled', true).parents('.form-group').hide()
)
