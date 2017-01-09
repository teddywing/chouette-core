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
      jp = journey_pattern_by_objectid(item['object_id']) || create_journey_pattern(item)
      raise "Unable to find or create journey_pattern !!" unless jp
      update_journey_pattern(jp, item)
    end

    respond_to do |format|
      format.json { render json: state }
    end
  end

  protected
  def update_jp jp, item
    jp.update_attributes(fetch_jp_attributes(item))
  end

  def fetch_jp_attributes item
    {
      name: item['name'],
      published_name: item['published_name'],
      registration_number: item['registration_number']
    }
  end

  def create_journey_pattern item
    jp = route.journey_patterns.create(fetch_jp_attributes(item))
    item['object_id'] = jp.objectid
    jp
  end

  def update_journey_pattern jp, item
    item['stop_points'].each do |sp|
      exist = jp.stop_area_ids.include?(sp['id'])
      next if exist && sp['checked']

      stop_point = route.stop_points.find_by(stop_area_id: sp['id'])
      if !exist && sp['checked']
        jp.stop_points << stop_point
        ap "adding stop_points to jp #{jp.objectid}"
      end
      if exist && !sp['checked']
        jp.stop_points.delete(stop_point)
        ap "deleting stop_points from jp #{jp.objectid}"
      end
    end
    update_jp(jp, item)
  end

  def journey_patterns_state
    @q = route.journey_patterns.includes(:stop_points)
    @journey_patterns ||= @q.paginate(:page => params[:page]).order(:name)
  end

  def journey_pattern_by_objectid objectid
    Chouette::JourneyPattern.find_by(objectid: objectid)
  end
end
