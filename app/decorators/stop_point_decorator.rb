class StopPointDecorator < AF83::Decorator
  decorates Chouette::StopPoint

  with_instance_decorator do |instance_decorator|
    instance_decorator.show_action_link do |l|
      l.href do
        h.referential_stop_area_path(
          object.referential,
          object.stop_area
        )
      end
    end

    instance_decorator.edit_action_link if: ->{ h.policy(Chouette::StopArea).update? } do |l|
      l.content h.t('stop_points.actions.edit')
      l.href do
        h.edit_stop_area_referential_stop_area_path(
          object.stop_area.stop_area_referential,
          object.stop_area
        )
      end
    end

    instance_decorator.destroy_action_link if: ->{ h.policy(Chouette::StopArea).destroy? } do |l|
      l.content h.destroy_link_content('stop_points.actions.destroy')
      l.href do
        h.referential_stop_area_path(
          object.referential,
          object.stop_area
        )
      end
      l.data confirm: h.t('stop_points.actions.destroy_confirm')
    end
  end
end
