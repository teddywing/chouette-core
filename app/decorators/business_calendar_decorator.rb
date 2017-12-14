class BusinessCalendarDecorator < Draper::Decorator
  delegate_all

  def action_links
    links = []

    if h.policy(object).update?
      links << Link.new(
        content: h.update_link_content,
        href: h.edit_business_calendar_path(object)
      )
    end

    if h.policy(object).destroy?
      links << Link.new(
        content: h.destroy_link_content,
        href: h.calendar_path(object),
        method: :delete,
        data: { confirm: h.t('calendars.actions.destroy_confirm') }
      )
    end

    links
  end
end