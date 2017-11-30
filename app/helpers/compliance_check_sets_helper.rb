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

    # Import statuses helper
  def compliance_check_set_status(status)
    if %w[new running pending].include? status
      content_tag :span, '', class: "fa fa-clock-o"
    else
      cls =''
      cls = 'success' if status == 'OK'
      cls = 'warning' if status == 'WARNING'
      cls = 'danger' if %w[ERROR IGNORED].include? status

      content_tag :span, '', class: "fa fa-circle text-#{cls}"
    end
  end
end
