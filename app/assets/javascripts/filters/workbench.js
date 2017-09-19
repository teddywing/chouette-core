const DateFilter = require('../helpers/date_filters')

$(document).ready(function(){
  const workbenchDF = new DateFilter("#referential_filter_btn", window.I18n.fr.referentials.error_period_filter, "#q_validity_period_begin_gteq_NUMi", "#q_validity_period_end_lteq_NUMi")
  workbenchDF()
})
