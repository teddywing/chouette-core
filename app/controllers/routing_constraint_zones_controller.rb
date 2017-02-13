class RoutingConstraintZonesController < ChouetteController
  defaults resource_class: Chouette::RoutingConstraintZone

  respond_to :html, :xml, :json

  belongs_to :referential do
    belongs_to :line, parent_class: Chouette::Line
  end

  before_action :check_policy, only: [:edit, :update, :destroy]

  protected
  def check_policy
    authorize resource
  end

  private
  def routing_constraint_zone_params
    params.require(:routing_constraint_zone).permit(:name, { stop_area_ids: [] }, :line_id, :objectid, :object_version, :creator_id)
  end

end
