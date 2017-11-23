module ComplianceCheckSetsHelper
  def compliance_check_set_path(compliance_check_set)
    workbench_compliance_check_set_path(compliance_check_set.workbench, compliance_check_set)
  end

  def executed_compliance_check_set_path(compliance_check_set)
    executed_workbench_compliance_check_set_path(compliance_check_set.workbench, compliance_check_set)
  end

  def compliance_check_path(compliance_check)
    workbench_compliance_check_set_compliance_check_path(
      compliance_check.compliance_check_set.workbench,
      compliance_check.compliance_check_set,
      compliance_check)
  end
end
