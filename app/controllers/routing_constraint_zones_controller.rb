class RoutingConstraintZonesController < ChouetteController
  include PolicyChecker

  defaults resource_class: Chouette::RoutingConstraintZone
  respond_to :html, :xml, :json

  before_action :check_stoppoint_param, only: [:create, :update]

  belongs_to :referential do
    belongs_to :line, parent_class: Chouette::Line
  end

  def index
    @routing_constraint_zones = collection
  end

  def show
    @routing_constraint_zone = collection.find(params[:id])
    @routing_constraint_zone = @routing_constraint_zone.decorate(context: {
      referential: @referential,
      line: @line
    })
  end

  protected

  def collection
    @q = resource.routing_constraint_zones.search(params[:q])

    if sort_column && sort_direction
      @routing_constraint_zones ||= @q.result(distinct: true).order(sort_column + ' ' + sort_direction)
    else
      @routing_constraint_zones ||= @q.result(distinct: true).order(:name)
    end
    @routing_constraint_zones = @routing_constraint_zones.paginate(page: params[:page], per_page: 10)
  end

  private
  def sort_column
    (Chouette::RoutingConstraintZone.column_names).include?(params[:sort]) ? params[:sort] : 'name'
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

  def resource
    @referential = Referential.find params[:referential_id]
    @line = @referential.lines.find params[:line_id]
  end

  def routing_constraint_zone_params
    params.require(:routing_constraint_zone).permit(
      :name,
      { stop_point_ids: [] },
      :line_id,
      :route_id,
      :objectid,
      :object_version,
      :creator_id
    )
  end

  def check_stoppoint_param
    spArr = []
    if params.require(:routing_constraint_zone)[:stop_point_ids] and params.require(:routing_constraint_zone)[:stop_point_ids].length >= 2
      params.require(:routing_constraint_zone)[:stop_point_ids].each do |k,v|
        spArr << v
      end
      params.require(:routing_constraint_zone)[:stop_point_ids] = spArr
    else
      Rails.logger.error("Error: An ITL must have at least two stop points")
    end
  end

end
