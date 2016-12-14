class JourneyPatternsCollectionsController < ChouetteController
  defaults :resource_class => Chouette::JourneyPattern

  respond_to :html
  respond_to :json

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end
  alias_method :route, :parent

  def show
    @q = route.journey_patterns.includes(:stop_points)
    @journey_patterns ||= @q.paginate(:page => params[:page]).order(:name)
  end

  def update
    ap "-----Call to #{params[:action]} from #{params[:controller]}"
    ap '------------------------------------------------------------'
    ap params
    ap '------------------------------------------------------------'
  end
end
