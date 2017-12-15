class BusinessCalendarDecorator < Draper::Decorator
  delegate_all

  def action_links
    links = []
    policy = h.policy(object)

    if policy.edit?
      links << Link.new(
        content: h.t('business_calendars.actions.edit'),
        href: h.edit_business_calendar_path(object)
      )
    end

    if policy.destroy?
      links << Link.new(
        content: h.destroy_link_content,
        href: h.business_calendar_path(object),
        method: :delete,
        data: { confirm: h.t('business_calendars.actions.destroy_confirm') }
      )
    end

    links
  end
end
