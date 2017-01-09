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
    jps_state
  end

  def update
    state = JSON.parse request.raw_post
    state.each do |item|
      jp = jp_by_objectid(item['object_id']) || create_jp(item)
      if item['deletable']
        state.delete(item) if jp.destroy
        next
      end
      update_journey_pattern(jp, item)
    end
    errors = state.any? {|item| item['errors']}

    respond_to do |format|
      format.json { render json: state, status: errors ? :unprocessable_entity : :ok }
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

  def create_jp item
    jp = route.journey_patterns.create(fetch_jp_attributes(item))
    if jp.persisted?
      item['object_id'] = jp.objectid
    else
      item['errors'] = jp.errors
    end
    jp
  end

  def update_journey_pattern jp, item
    item['stop_points'].each do |sp|
      exist = jp.stop_area_ids.include?(sp['id'])
      next if exist && sp['checked']

      stop_point = route.stop_points.find_by(stop_area_id: sp['id'])
      if !exist && sp['checked']
        jp.stop_points << stop_point
      end
      if exist && !sp['checked']
        jp.stop_points.delete(stop_point)
      end
    end
    update_jp(jp, item)
  end

  def jps_state
    @q = route.journey_patterns.includes(:stop_points)
    @journey_patterns ||= @q.paginate(:page => params[:page]).order(:name)
  end

  def jp_by_objectid objectid
    Chouette::JourneyPattern.find_by(objectid: objectid)
  end
end
