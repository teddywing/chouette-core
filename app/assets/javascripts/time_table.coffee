 $(document).on("click", "#time_table_filter_btn", (e) ->
   dates = [1, 2, 3].reduce (arr, key) ->
     arr.push $("#q_start_date_gteq_#{key}i").val(), $("#q_end_date_lteq_#{key}i").val()
     arr
   , []

   validDate = dates.every (date) -> !!date

   noDate = dates.every (date) -> !date

   unless (validDate || noDate)
     e.preventDefault()
     alert(window.I18n.fr.time_tables.error_period_filter)
 )
