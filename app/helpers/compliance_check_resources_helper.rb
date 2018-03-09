module ComplianceCheckResourcesHelper

    # Comlpiance Check Resources statuses helper
  def compliance_check_resource_status(status)
      cls = ''
      cls = 'success' if status == 'OK'
      cls = 'warning' if %w[WARNING IGNORED].include? status
      cls = 'danger' if status == 'ERROR'

      content_tag :span, '', class: "fa fa-circle text-#{cls}"
  end
end
