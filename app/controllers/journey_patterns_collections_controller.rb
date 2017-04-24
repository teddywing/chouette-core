class JourneyPatternsCollectionsController < ChouetteController
  respond_to :html
  respond_to :json
  before_action :user_permissions, only: :show

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end
  alias_method :route, :parent

  def show
    @q = route.journey_patterns.search(params[:q]).result(distinct: true).includes(:stop_points)
    @ppage = 10
    @journey_patterns ||= @q.paginate(page: params[:page], per_page: @ppage).order(:name)

    @stop_points_list = []
    route.stop_points.each do |sp|
      @stop_points_list << {
        :id => sp.stop_area.id,
        :route_id => sp.try(:route_id),
        :object_id => sp.try(:objectid),
        :position => sp.try(:position),
        :for_boarding => sp.try(:for_boarding),
        :for_alighting => sp.try(:for_alighting),
        :name => sp.stop_area.try(:name),
        :zip_code => sp.stop_area.try(:zip_code),
        :city_name => sp.stop_area.try(:city_name),
        :comment => sp.stop_area.try(:comment),
        :area_type => sp.stop_area.try(:area_type),
        :registration_number => sp.stop_area.try(:registration_number),
        :nearest_topic_name => sp.stop_area.try(:nearest_topic_name),
        :fare_code => sp.stop_area.try(:fare_code),
        :longitude => sp.stop_area.try(:longitude),
        :latitude => sp.stop_area.try(:latitude),
        :long_lat_type => sp.stop_area.try(:long_lat_type),
        :country_code => sp.stop_area.try(:country_code),
        :street_name => sp.stop_area.try(:street_name)
      }
    end
    @stop_points_list = @stop_points_list.sort_by {|a| a[:position] }
  end

  def user_permissions
    @perms = {}.tap do |perm|
      ['journey_patterns.create', 'journey_patterns.edit', 'journey_patterns.destroy'].each do |name|
        perm[name] = policy(:journey_pattern).send("#{name.split('.').last}?")
      end
    end.to_json
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
