class CalendarDecorator < AF83::Decorator
  decorates Calendar
  
  action_link on: :index, primary: :index, policy: :create do |l|
    l.content { h.t('actions.add') }
    l.href    { h.new_calendar_path }
  end

  with_instance_decorator do |instance_decorator|
    instance_decorator.action_link primary: :index do |l|
      l.content { h.t('actions.show') }
      l.href { [object] }
    end

    instance_decorator.action_link primary: %i(show index) do |l|
      l.content { h.t('actions.edit') }
      l.href { [object] }
    end

    instance_decorator.action_link policy: :destroy, footer: true, secondary: :show  do |l|
      l.content { h.destroy_link_content }
      l.href { h.calendar_path(object) }
      l.method { :delete }
      l.data {{ confirm: h.t('calendars.actions.destroy_confirm') }}
    end
  end
end
