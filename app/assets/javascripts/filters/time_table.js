$(document).ready(function(){
  const DateFilter = require('../helpers/date_filters')

  const timetableDF = new DateFilter("#time_table_filter_btn", window.I18n.fr.time_tables.error_period_filter, "#q_bounding_dates_start_date_NUMi", "#q_bounding_dates_end_date_NUMi")

  timetableDF()
})
