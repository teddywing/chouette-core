class CalendarDecorator < Draper::Decorator
  delegate_all

  def action_links
    links = []

    if h.policy(object).destroy?
      links << Link.new(
        content: h.destroy_link_content,
        href: h.workgroup_calendar_path(context[:workgroup], object),
        method: :delete,
        data: { confirm: h.t('calendars.actions.destroy_confirm') }
      )
    end

    links
  end
end
