class RouteStopPointsController < ChouetteController
  defaults resource_class: Chouette::StopPoint
  actions :index
  respond_to :json, only: :index

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end

  def index
    respond_to do |format|
      format.json { render json: referential.lines.find(params[:line_id]).routes.find(params[:route_id]).stop_points.map { |sp| { id: sp.id, name: sp.name } } }
    end
  end
end

