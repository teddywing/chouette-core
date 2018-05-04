class ReferentialConsolidated
  attr_reader :params

  def initialize vehicle_journeys, params
    @vehicle_journeys = vehicle_journeys
    @params = params
  end

  def paginated_lines
    @paginated_lines ||= begin
      line_ids = @vehicle_journeys.joins(route: :line).pluck('lines.id')
      lines = Chouette::Line.where(id: line_ids).order(:name)
      lines.paginate page: params[:page], per_page: params[:per_page] || 10
    end
  end

  def lines
    @lines ||= paginated_lines.to_a.map {|l| Line.new(self, l, @vehicle_journeys, params) }
  end

  def _should_highlight?
    return false unless params[:q].present?
    keys = params[:q].keys - ["stop_areas"]
    params[:q].values_at(*keys).each do |value|
      if value.is_a?(Hash)
        return true if value.values.any?(&:present?)
      elsif value.is_a?(Array)
        return true if value.any?(&:present?)
      else
        if value.present?
          return true
        end
      end
    end
    false
  end

  def should_highlight?
    if @should_highlight.nil?
      @should_highlight = _should_highlight?
    end
    @should_highlight
  end

  class Base
    extend Forwardable
    attr_reader :params
    attr_reader :parent
    attr_reader :ar_model

    def initialize parent, ar_model, vehicle_journeys, params
      @parent = parent
      @ar_model = ar_model
      @all_vehicle_journeys = vehicle_journeys
      @params = params
    end

    def should_highlight?
      parent.should_highlight?
    end
  end

  class Line < Base
    delegate name: :ar_model
    delegate id: :ar_model

    def routes
      @routes ||= begin
        ar_model.routes.order(:name).map {|r| Route.new(self, r, @all_vehicle_journeys, params) }
      end
    end
  end

  class Route < Base
    def_delegators :ar_model, :name, :id, :time_tables, :purchase_windows, :stop_area_ids

    def vehicle_journeys
      @vehicle_journeys ||= begin
        ar_model.vehicle_journeys.map {|vj| VehicleJourney.new(self, vj, @all_vehicle_journeys, params) }
      end
    end

    def highlighted_journeys
      @all_vehicle_journeys.joins(:journey_pattern).where(route_id: self.id)
    end

    def highlighted_count
      highlighted_journeys.count
    end

    def highlighted?
      matching_stop_areas = params[:q]["stop_areas"] && (params[:q]["stop_areas"].values & self.stop_area_ids.map(&:to_s)).present?
      (should_highlight? || matching_stop_areas) && highlighted_journeys.exists?
    end

    def stop_points
      @stop_points ||= ar_model.stop_points.map {|sp| StopPoint.new(self, sp, @all_vehicle_journeys, params) }
    end
  end

  class VehicleJourney < Base
    def_delegators :ar_model, :id, :published_journey_name, :journey_pattern, :time_tables, :purchase_windows, :vehicle_journey_at_stops, :time_table_ids, :purchase_window_ids, :route

    def highlighted?
      should_highlight? && @all_vehicle_journeys.where(id: self.id).exists?
    end

    def has_purchase_window? purchase_window
      purchase_window_ids.include?(purchase_window.id)
    end

    def has_time_table? time_table
      time_table_ids.include?(time_table.id)
    end
  end

  class StopPoint < Base
    def_delegators :ar_model, :id, :arrival_time, :departure_time, :name, :stop_area, :stop_area_id

    def highlighted?
      params[:q]["stop_areas"] && params[:q]["stop_areas"].values.any?{|v| v.to_s == stop_area_id.to_s}
    end
  end
end
