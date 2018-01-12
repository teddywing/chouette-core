module ComplianceCheckResourcesHelper

    # Comlpiance Check Resources statuses helper
  def compliance_check_resource_status(status)
      cls = ''
      cls = 'success' if status == 'OK'
      cls = 'warning' if status == 'WARNING'
      cls = 'danger' if %w[ERROR IGNORED].include? status

      content_tag :span, '', class: "fa fa-circle text-#{cls}"
  end
end
