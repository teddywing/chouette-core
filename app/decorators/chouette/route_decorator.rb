# TODO: Figure out @referential, @line, @route_sp
class Chouette::RouteDecorator < Draper::Decorator
  delegate_all

  def action_links
    links = []

    if @route_sp.any?
      links << Link.new(
        content: h.t('journey_patterns.index.title'),
        href: [@referential, @line, object, :journey_patterns_collection]
      )
    end

    if object.journey_patterns.present?
      links << Link.new(
        content: h.t('vehicle_journeys.actions.index'),
        href: [@referential, @line, object, :vehicle_journeys]
      )
    end

    links << Link.new(
      content: h.t('vehicle_journey_exports.new.title'),
      href: h.referential_line_route_vehicle_journey_exports_path(
        @referential,
        @line,
        object,
        format: :zip
      )
    )

    if h.policy(object).destroy?
      links << Link.new(
        content: h.destroy_link_content,
        href: h.referential_line_route_path(@referential, @line, object),
        method: :delete,
        data: { confirm: h.t('routes.actions.destroy_confirm') }
      )
    end

    links
  end
end
