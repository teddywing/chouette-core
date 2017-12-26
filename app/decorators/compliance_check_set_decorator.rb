class ComplianceCheckSetDecorator < Draper::Decorator
  delegate_all

  def action_links
    links = []
  end

  def lines_status
    object.compliance_check_resources.where(status: :OK, resource_type: :line).count
  end

  def lines_in_compliance_check_set
    object.compliance_check_resources.where(resource_type: :line).count
  end

end
