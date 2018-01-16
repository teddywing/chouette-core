class TimeTableDecorator < AF83::Decorator
  decorates Chouette::TimeTable

  with_instance_decorator do |instance_decorator|
    instance_decorator.action_link primary: :index do |l|
      l.content { h.t('actions.show') }
      l.href { [context[:referential], object] }
    end

    instance_decorator.action_link primary: %i(show index) do |l|
      l.content { h.t('actions.edit') }
      l.href { [context[:referential], object] }
    end

    instance_decorator.action_link if: ->{ object.calendar }, secondary: true do |l|
      l.content { h.t('actions.actualize') }
      l.href do
         h.actualize_referential_time_table_path(
          context[:referential],
          object
        )
      end
      l.method :post
    end

    instance_decorator.action_link policy: :edit, secondary: true do |l|
      l.content { h.t('actions.combine') }
      l.href do
        h.new_referential_time_table_time_table_combination_path(
          context[:referential],
          object
        )
      end
    end

    instance_decorator.action_link policy: :duplicate, secondary: true do |l|
      l.content { h.t('actions.duplicate') }
      l.href do
        h.duplicate_referential_time_table_path(
          context[:referential],
          object
        )
      end
    end

    instance_decorator.action_link policy: :destroy, footer: true, secondary: :show  do |l|
      l.content { h.destroy_link_content }
      l.href do
        h.duplicate_referential_time_table_path(
          context[:referential],
          object
        )
      end
      l.method { :delete }
      l.data {{ confirm: h.t('time_tables.actions.destroy_confirm') }}
    end
  end
end
