const DateFilter = require('../helpers/date_filters')

$(document).ready(function () {
  const complianceControlSetDF = new DateFilter("#compliance_control_set_filter_btn", "Tous les champs du filtre de date doivent être remplis", "#q_updated_at_start_date_NUMi", "#q_updated_at_end_date_NUMi")
  complianceControlSetDF()
})
