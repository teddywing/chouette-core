# TODO: Figure out @referential, @line
class Chouette::RoutingConstraintZoneDecorator < Draper::Decorator
  delegate_all

  def action_links
    links = []

    if h.policy(object).update?
      links << Link.new(
        content: h.t('actions.edit'),
        href: h.edit_referential_line_routing_constraint_zone_path(
          @referential,
          @line,
          object
        )
      )

    if h.policy(object).destroy?
      links << Link.new(
        content: h.destroy_link_content,
        href: h.referential_line_routing_constraint_zone_path(
          @referential,
          @line,
          object
        ),
        method: :delete,
        data: {
          confirm: h.t('routing_constraint_zones.actions.destroy_confirm')
        }
      )
    end

    links
  end
end
