module ComplianceCheckSetsHelper
  def compliance_check_set_path(compliance_check_set)
    workbench_compliance_check_set_path(compliance_check_set.workbench, compliance_check_set)
  end
end
