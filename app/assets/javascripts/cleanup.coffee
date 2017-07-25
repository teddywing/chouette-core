$(document).on("change", 'input[name="clean_up[date_type]"]', (e) ->
  type = $(this).val()
  end_date = $('.cleanup_end_date_wrapper')

  if type == 'before'
    end_date.hide()
    $('label.begin_date').addClass 'hidden'
    $('label.end_date').removeClass 'hidden'

  else if type == 'after'
    end_date.hide()
    $('label.begin_date').removeClass 'hidden'
    $('label.end_date').addClass 'hidden'

  else
    $('label.begin_date').removeClass 'hidden'
    $('label.end_date').addClass 'hidden'
    end_date.show()
)
