class VehicleJourneysController < ChouetteController
  include ReferentialSupport
  defaults :resource_class => Chouette::VehicleJourney
  before_action :user_permissions, only: :index

  respond_to :json, :only => :index
  respond_to :js, :only => [:select_journey_pattern, :select_vehicle_journey, :edit, :new, :index]

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end

  include PolicyChecker
  alias_method :vehicle_journeys, :collection
  alias_method :route, :parent
  alias_method :vehicle_journey, :resource

  def select_journey_pattern
    if params[:journey_pattern_id]
      selected_journey_pattern = Chouette::JourneyPattern.find(params[:journey_pattern_id])

      @vehicle_journey = vehicle_journey
      @vehicle_journey.update_journey_pattern(selected_journey_pattern)
    end
  end
  def select_vehicle_journey
    if params[:vehicle_journey_objectid]
      @vehicle_journey = Chouette::VehicleJourney.find(params[:vehicle_journey_objectid])
    end
  end

  def create
    create!(:alert => t('activerecord.errors.models.vehicle_journey.invalid_times'))
  end

  def update
    update!(:alert => t('activerecord.errors.models.vehicle_journey.invalid_times'))
  end

  def index
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

    @transport_mode = route.line['transport_mode']
    @transport_submode = route.line['transport_submode']

    if params[:jp]
      @jp_origin  = Chouette::JourneyPattern.find_by(objectid: params[:jp])
      @jp_origin_stop_points = @jp_origin.stop_points
    end

    index! do
      if collection.out_of_bounds?
        redirect_to params.merge(:page => 1)
      end
    end
  end

  # overwrite inherited resources to use delete instead of destroy
  # foreign keys will propagate deletion)
  def destroy_resource(object)
    object.delete
  end

  protected
  def collection
    scope = route.vehicle_journeys.with_stops
    scope = maybe_filter_by_departure_time(scope)
    scope = maybe_filter_out_journeys_with_time_tables(scope)

    @q = scope.search filtered_ransack_params

    @ppage = 20
    @vehicle_journeys = @q.result.paginate(:page => params[:page], :per_page => @ppage)
    @footnotes = route.line.footnotes.to_json
    @matrix    = resource_class.matrix(@vehicle_journeys)
    @vehicle_journeys
  end

  def maybe_filter_by_departure_time(scope)
    if params[:q] &&
        params[:q][:vehicle_journey_at_stops_departure_time_gteq] &&
        params[:q][:vehicle_journey_at_stops_departure_time_lteq]
      scope = scope.where_departure_time_between(
        params[:q][:vehicle_journey_at_stops_departure_time_gteq],
        params[:q][:vehicle_journey_at_stops_departure_time_lteq],
        allow_empty:
          params[:q][:vehicle_journey_without_departure_time] == 'true'
      )
    end

    scope
  end

  def maybe_filter_out_journeys_with_time_tables(scope)
    if params[:q] && params[:q][:vehicle_journey_without_time_table] == 'false'
      return scope.without_time_tables
    end

    # if params[:q]
    #   if params[:q][:vehicle_journey_without_time_table] == 'true'
    #     return scope.without_time_tables
    #   end
    # else
    #   return scope.without_time_tables
    # end

    scope
  end

  def filtered_ransack_params
    if params[:q]
      params[:q] = params[:q].reject{|k| params[:q][k] == 'undefined'}
      params[:q].except(:vehicle_journey_at_stops_departure_time_gteq, :vehicle_journey_at_stops_departure_time_lteq)
    end
  end

  def adapted_params
    params.tap do |adapted_params|
      adapted_params.merge!(:route => parent)
      hour_entry = "vehicle_journey_at_stops_departure_time_gt(4i)".to_sym
      if params[:q] && params[:q][ hour_entry]
        adapted_params[:q].merge! hour_entry => (params[:q][ hour_entry].to_i - utc_offset)
      end
    end
  end
  def utc_offset
    # Ransack Time eval - utc eval
    sample = [2001,1,1,10,0]
    Time.zone.local(*sample).utc.hour - Time.utc(*sample).hour
  end

  def matrix
    @matrix = resource_class.matrix(@vehicle_journeys)
  end

  def user_permissions
    policy = policy(:vehicle_journey)
    @perms =
      %w{create destroy update}.inject({}) do | permissions, action |
        permissions.merge( "vehicle_journeys.#{action}" => policy.authorizes_action?(action) )
      end.to_json
  end

  private
  def vehicle_journey_params
    params.require(:vehicle_journey).permit(
      { footnote_ids: [] },
      :journey_pattern_id,
      :number,
      :published_journey_name,
      :published_journey_identifier,
      :comment,
      :transport_mode,
      :mobility_restricted_suitability,
      :flexible_service,
      :status_value,
      :facility,
      :vehicle_type_identifier,
      :objectid,
      :time_table_tokens,
      { date: [:hour, :minute] },
      :button,
      :referential_id,
      :line_id,
      :route_id,
      :id,
      { vehicle_journey_at_stops_attributes: [:arrival_time, :id, :_destroy, :stop_point_id, :departure_time] }
    )
  end
end
