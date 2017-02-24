class JourneyPatternsCollectionsController < ChouetteController
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
    @ppage = 3
    @journey_patterns ||= @q.paginate(page: params[:page], per_page: @ppage).order(:name)
  end

  def update
    state  = JSON.parse request.raw_post
    Chouette::JourneyPattern.state_update route, state
    errors = state.any? {|item| item['errors']}

    respond_to do |format|
      format.json { render json: state, status: errors ? :unprocessable_entity : :ok }
    end
  end

  protected
end
