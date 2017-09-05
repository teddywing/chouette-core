const DateFilter = require('../helpers/date_filters')

$(document).ready(function(){
  const calendarDF = new DateFilter("#calendar_filter_btn", "Tous les champs du filtre de date doivent être remplis", "#q_contains_date_NUMi")
  calendarDF()
})
