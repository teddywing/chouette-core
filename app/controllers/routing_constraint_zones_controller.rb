class RoutingConstraintZonesController < ChouetteController
  defaults resource_class: Chouette::RoutingConstraintZone

  respond_to :html, :xml, :json

  before_action :remove_empty_stop_point, only: [:create, :update]

  belongs_to :referential do
    belongs_to :line, parent_class: Chouette::Line
  end

  include PolicyChecker

  private
  def routing_constraint_zone_params
    params.require(:routing_constraint_zone).permit(:name, { stop_point_ids: [] }, :line_id, :route_id, :objectid, :object_version, :creator_id)
  end

  def remove_empty_stop_point
    params.require(:routing_constraint_zone)[:stop_point_ids].delete('')
  end
end
