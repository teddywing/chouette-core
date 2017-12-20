class ReferentialLineDecorator < Draper::Decorator
  decorates Chouette::Line

  delegate_all

  # Requires:
  #   context: {
  #     referential: ,
  #     current_organisation:
  #   }
  def action_links
    links = []

    links << Link.new(
      content: Chouette::Line.human_attribute_name(:footnotes),
      href: h.referential_line_footnotes_path(context[:referential], object)
    )

    links << Link.new(
      content: h.t('routing_constraint_zones.index.title'),
      href: h.referential_line_routing_constraint_zones_path(
        context[:referential],
        object
      )
    )

    if !object.hub_restricted? ||
        (object.hub_restricted? && object.routes.size < 2)
      if h.policy(Chouette::Route).create? &&
          context[:referential].organisation == context[:current_organisation]
        links << Link.new(
          content: h.t('routes.actions.new'),
          href: h.new_referential_line_route_path(context[:referential], object)
        )
      end
    end

    links
  end
end
