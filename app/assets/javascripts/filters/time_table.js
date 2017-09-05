$(document).ready(function(){
  const DateFilter = require('../helpers/date_filters')

  const timetableDF = new DateFilter("#time_table_filter_btn", window.I18n.fr.time_tables.error_period_filter, "#q_start_date_gteq_NUMi", "#q_end_date_lteq_NUMi")

  timetableDF()
})
