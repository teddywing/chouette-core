 $(document).on("click", "#referential_filter_btn", (e) ->
   dates = [1, 2, 3].reduce (arr, key) ->
     arr.push $("#q_validity_period_begin_gteq_#{key}i").val(), $("#q_validity_period_end_gteq__#{key}i").val()
     arr
   , []

   validDate = dates.every (date) -> !!date

   noDate = dates.every (date) -> !date

   unless (validDate || noDate)
     e.preventDefault()
     alert(window.I18n.fr.referentials.error_period_filter)
 )
