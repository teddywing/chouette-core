class RoutingConstraintZoneDecorator < AF83::Decorator
  decorates Chouette::RoutingConstraintZone

  # Action links require:
  #   context: {
  #     referential: ,
  #     line:
  #   }

  create_action_link(
    if: ->() {
      h.policy(Chouette::RoutingConstraintZone).create? &&
        context[:referential].organisation == h.current_organisation
    }
  ) do |l|
    l.href do
      h.new_referential_line_routing_constraint_zone_path(
       context[:referential],
       context[:line]
     )
    end
    l.class 'btn btn-primary'
  end

  with_instance_decorator do |instance_decorator|
    instance_decorator.show_action_link do |l|
      l.href do
        h.referential_line_routing_constraint_zone_path(
          context[:referential],
          context[:line],
          object
        )
      end
    end

    instance_decorator.edit_action_link do |l|
      l.href do
        h.edit_referential_line_routing_constraint_zone_path(
          context[:referential],
          context[:line],
          object
        )
      end
    end

    instance_decorator.destroy_action_link do |l|
      l.href do
        h.referential_line_routing_constraint_zone_path(
          context[:referential],
          context[:line],
          object
        )
      end
      l.data confirm: h.t('routing_constraint_zones.actions.destroy_confirm')
    end
  end
end
