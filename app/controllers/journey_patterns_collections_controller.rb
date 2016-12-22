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
    journey_patterns_state
  end

  def update
    state = JSON.parse request.raw_post
    state.each do |item|
      journey_pattern = journey_pattern_by_objectid(item['object_id'])
      journey_pattern_update_stop_points(journey_pattern, item['stop_points']) if journey_pattern
    end

    journey_patterns_state
  end

  protected

  def journey_pattern_update_stop_points journey_pattern, stop_points
    stop_points.each do |sp|
      stop_id = sp['id']
      exist   = journey_pattern.stop_area_ids.include?(stop_id)
      next if exist && sp['checked']

      stop_point = route.stop_points.find_by(stop_area_id: stop_id)
      if sp['checked'] && !exist
        journey_pattern.stop_points << stop_point
      else
        journey_pattern.stop_points.delete(stop_point)
      end
    end
  end

  def journey_patterns_state
    @q = route.journey_patterns.includes(:stop_points)
    @journey_patterns ||= @q.paginate(:page => params[:page]).order(:name)
  end

  def journey_pattern_by_objectid objectid
    Chouette::JourneyPattern.find_by(objectid: objectid)
  end
end
