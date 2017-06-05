$(document).on("change", 'input[name="clean_up[date_type]"]', (e) ->
  type = $(this).val()
  end_date = $('.cleanup_end_date_wrapper')

  if type == 'between'
    end_date.removeClass('hidden').show()
  else
    end_date.hide()
)
