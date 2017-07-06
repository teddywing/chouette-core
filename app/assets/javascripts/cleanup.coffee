$(document).on("change", 'input[name="clean_up[date_type]"]', (e) ->
  type = $(this).val()
  end_date = $('.cleanup_end_date_wrapper')

  if type == 'before'
    end_date.hide()
    $("label[for='clean_up_begin_date_3i']").html("Date de fin de la purge");
  else if type == 'after'
    end_date.hide()
    $("label[for='clean_up_begin_date_3i']").html("Date de début de la purge");
  else
    $("label[for='clean_up_begin_date_3i']").html("Date de début de la purge");
    end_date.show()
)
