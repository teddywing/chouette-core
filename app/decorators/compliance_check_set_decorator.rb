class ComplianceCheckSetDecorator < Draper::Decorator
  delegate_all

  def action_links
    links = []

    links << Link.new(
      content: h.destroy_link_content,
      href: h.workbench_compliance_check_sets_path(object.id),
      method: :delete,
      data: {confirm: h.t('imports.actions.destroy_confirm')}
    )

    links
  end

  def lines_status
    object.compliance_check_resources.where(status: :OK, resource_type: :line).count
  end

  def lines_in_compliance_check_set
    object.compliance_check_resources.where(resource_type: :line).count
  end

end
