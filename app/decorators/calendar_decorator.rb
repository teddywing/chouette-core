class CalendarDecorator < AF83::Decorator
  decorates Calendar

  set_scope { context[:workgroup] }

  create_action_link

<<<<<<< HEAD
  with_instance_decorator do |instance_decorator|
    instance_decorator.show_action_link
    instance_decorator.edit_action_link
    instance_decorator.destroy_action_link do |l|
      l.data {{ confirm: h.t('calendars.actions.destroy_confirm') }}
=======
    if h.policy(object).destroy?
      links << Link.new(
        content: h.destroy_link_content,
        href: h.workgroup_calendar_path(context[:workgroup], object),
        method: :delete,
        data: { confirm: h.t('calendars.actions.destroy_confirm') }
      )
>>>>>>> First draft for including calendars into workgroup for having appropriate scoping
    end
  end
end
