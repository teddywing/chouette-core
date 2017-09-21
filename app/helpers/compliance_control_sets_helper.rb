module ComplianceControlSetsHelper

  def organisations_filters_values
    [current_organisation, Organisation.find_by_name("STIF")].uniq
  end

end
