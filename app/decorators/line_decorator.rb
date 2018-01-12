class LineDecorator < Draper::Decorator
  decorates Chouette::Line

  delegate_all

  # Requires:
  #   context: {
  #     line_referential: ,
  #     current_organisation:
  #   }
  def action_links
    links = []

    links << Link.new(
      content: h.t('lines.actions.show_network'),
      href: [context[:line_referential], object.network]
    )

    links << Link.new(
      content: h.t('lines.actions.show_company'),
      href: [context[:line_referential], object.company],
      disabled: object.company.nil?
    )

    if h.policy(Chouette::Line).create? &&
      context[:line_referential].organisations.include?(
        context[:current_organisation]
      )
      links << Link.new(
        content: h.t('lines.actions.edit'),
        href: h.edit_line_referential_line_path(context[:line_referential], object.id)
      )
    end

    if h.policy(Chouette::Line).create? &&
      context[:line_referential].organisations.include?(
        context[:current_organisation]
      )
      links << Link.new(
        content: h.t('lines.actions.new'),
        href: h.new_line_referential_line_path(context[:line_referential])
      )
    end

    if h.policy(object).deactivate?
      links << Link.new(
        content: h.deactivate_link_content('lines.actions.deactivate'),
        href: h.deactivate_line_referential_line_path(context[:line_referential], object),
        method: :put,
        data: {confirm: h.t('lines.actions.deactivate_confirm')},
        extra_class: "delete-action"
      )
    end

    if h.policy(object).activate?
      links << Link.new(
        content: h.activate_link_content('lines.actions.activate'),
        href: h.activate_line_referential_line_path(context[:line_referential], object),
        method: :put,
        data: {confirm: h.t('lines.actions.activate_confirm')},
        extra_class: "delete-action"
      )
    end

    if h.policy(object).destroy?
      links << Link.new(
        content: h.destroy_link_content('lines.actions.destroy'),
        href: h.line_referential_line_path(context[:line_referential], object),
        method: :delete,
        data: {confirm: h.t('lines.actions.destroy_confirm')}
      )
    end

    links
  end
end
