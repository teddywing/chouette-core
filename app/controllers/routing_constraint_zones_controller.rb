class RoutingConstraintZonesController < ChouetteController
  defaults resource_class: Chouette::RoutingConstraintZone

  respond_to :html, :xml, :json

  belongs_to :referential do
    belongs_to :line, parent_class: Chouette::Line
  end

  private
  def routing_constraint_zone_params
    params.require(:routing_constraint_zone).permit(:name, { stop_area_ids: [] }, :line_id, :objectid, :object_version, :creation_time, :creator_id)
  end

end
