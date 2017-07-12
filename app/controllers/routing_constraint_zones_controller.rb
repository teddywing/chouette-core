class RoutingConstraintZonesController < ChouetteController
  include PolicyChecker

  defaults resource_class: Chouette::RoutingConstraintZone
  respond_to :html, :xml, :json

  # before_action :check_stoppoint_param, only: [:create, :update]

  belongs_to :referential do
    belongs_to :line, parent_class: Chouette::Line
  end

  def index
    index! do |format|
      @routing_constraint_zones = ModelDecorator.decorate(
        @routing_constraint_zones,
        with: RoutingConstraintZoneDecorator,
        context: {
          referential: referential,
          line: parent
        }
      )

      build_breadcrumb :index
    end
  end

  def show
    show! do |format|
      @routing_constraint_zone = @routing_constraint_zone.decorate(context: {
        referential: referential,
        line: parent
      })

      build_breadcrumb :show
    end
  end

  def new
    new! do |format|
      format.html
      format.js {
        # Get selected route in the form view
        @route = @line.routes.find params[:route_id] if params[:route_id]
        # Get the routing_constraint_zone, the main use is when validation failed
        routing_constraint_zone = @line.routing_constraint_zones.new(JSON(params[:routing_constraint_zone_json])) if params[:routing_constraint_zone_json]
        @routing_constraint_zone = routing_constraint_zone || build_resource
      }
    end
  end

  protected

  alias_method :routing_constraint_zone, :resource
  alias_method :line, :parent

  def collection
    @q = current_referential.routing_constraint_zones.search(params[:q])

    @routing_constraint_zones ||= begin
      if sort_column && sort_direction
        routing_constraint_zones = @q.result(distinct: true).order(sort_column + ' ' + sort_direction)
      else
        routing_constraint_zones = @q.result(distinct: true).order(:name)
      end
      routing_constraint_zones = routing_constraint_zones.paginate(page: params[:page], per_page: 10)
    end
  end

  private
  def sort_column
    (Chouette::RoutingConstraintZone.column_names).include?(params[:sort]) ? params[:sort] : 'name'
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
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
