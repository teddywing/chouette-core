class ComplianceControlSetDecorator < Draper::Decorator
  delegate_all

  def action_links
    links = []

    # if h.policy(object).destroy?
      links << Link.new(
        content: h.destroy_link_content,
        href: h.compliance_control_set_path(object.id),
        method: :delete,
        data: { confirm: h.t('compliance_control_sets.actions.destroy_confirm') }
      )
    # end

    # if h.policy(object).edit?
      links << Link.new(
        content: h.t('compliance_control_sets.actions.edit'),
        href:  h.edit_compliance_control_set_path(object.id)
      )
    # end
    links
  end

end

