module Chouette
  class VehicleJourney < TridentActiveRecord
    include VehicleJourneyRestrictions
    include StifTransportModeEnumerations
    # FIXME http://jira.codehaus.org/browse/JRUBY-6358
    self.primary_key = "id"

    enum journey_category: { timed: 0, frequency: 1 }

    default_scope { where(journey_category: journey_categories[:timed]) }

    attr_reader :time_table_tokens

    def self.nullable_attributes
      [:transport_mode, :published_journey_name, :vehicle_type_identifier, :published_journey_identifier, :comment, :status_value]
    end

    belongs_to :company
    belongs_to :route
    belongs_to :journey_pattern

    has_and_belongs_to_many :footnotes, :class_name => 'Chouette::Footnote'

    validates_presence_of :route
    validates_presence_of :journey_pattern

    has_many :vehicle_journey_at_stops, -> { includes(:stop_point).order("stop_points.position") }, :dependent => :destroy
    has_and_belongs_to_many :time_tables, :class_name => 'Chouette::TimeTable', :foreign_key => "vehicle_journey_id", :association_foreign_key => "time_table_id"
    has_many :stop_points, -> { order("stop_points.position") }, :through => :vehicle_journey_at_stops

    validate :increasing_times
    validates_presence_of :number

    before_validation :set_default_values
    def set_default_values
      if number.nil?
        self.number = 0
      end
    end

    scope :without_any_time_table, -> { joins('LEFT JOIN "time_tables_vehicle_journeys" ON "time_tables_vehicle_journeys"."vehicle_journey_id" = "vehicle_journeys"."id" LEFT JOIN "time_tables" ON "time_tables"."id" = "time_tables_vehicle_journeys"."time_table_id"').where(:time_tables => { :id => nil}) }
    scope :without_any_passing_time, -> { joins('LEFT JOIN "vehicle_journey_at_stops" ON "vehicle_journey_at_stops"."vehicle_journey_id" = "vehicle_journeys"."id"').where(vehicle_journey_at_stops: { id: nil }) }

    accepts_nested_attributes_for :vehicle_journey_at_stops, :allow_destroy => true

    def presenter
      @presenter ||= ::VehicleJourneyPresenter.new( self)
    end

    def vehicle_journey_at_stops_matrix
      fill = route.stop_points.count - self.vehicle_journey_at_stops.count
      at_stops = self.vehicle_journey_at_stops.to_a.dup
      fill.times do
        at_stops << Chouette::VehicleJourneyAtStop.new
      end
      at_stops
    end

    def update_vehicle_journey_at_stops_state state
      state.each do |vjas|
        next if vjas["dummy"]
        stop = vehicle_journey_at_stops.find(vjas['id']) if vjas['id']
        if stop
          stop.arrival_time   ||= Time.now.beginning_of_day
          stop.departure_time ||= Time.now.beginning_of_day
          ['arrival_time', 'departure_time'].each do |field|
            stop.assign_attributes({
              field.to_sym => stop.send(field).change({ hour: vjas[field]['hour'], min: vjas[field]['minute'] })
            })
          end
          stop.save
        end
      end
    end

    def self.state_update route, state
      transaction do
        state.each do |item|
          item.delete('errors')
          vj = find_by(objectid: item['objectid'])
          vj.update_vehicle_journey_at_stops_state(item['vehicle_journey_at_stops'])
          item['errors'] = vj.errors if vj.errors.any?
        end

        if state.any? {|item| item['errors']}
          raise ActiveRecord::Rollback
        end
      end
    end

    def increasing_times
      previous = nil
      vehicle_journey_at_stops.select{|vjas| vjas.departure_time && vjas.arrival_time}.each do |vjas|
        errors.add( :vehicle_journey_at_stops, 'time gap overflow') unless vjas.increasing_times_validate( previous)
        previous = vjas
      end
    end

    def missing_stops_in_relation_to_a_journey_pattern(selected_journey_pattern)
      selected_journey_pattern.stop_points - self.stop_points
    end
    def extra_stops_in_relation_to_a_journey_pattern(selected_journey_pattern)
      self.stop_points - selected_journey_pattern.stop_points
    end
    def extra_vjas_in_relation_to_a_journey_pattern(selected_journey_pattern)
      extra_stops = self.extra_stops_in_relation_to_a_journey_pattern(selected_journey_pattern)
      self.vehicle_journey_at_stops.select { |vjas| extra_stops.include?( vjas.stop_point)}
    end
    def time_table_tokens=(ids)
      self.time_table_ids = ids.split(",")
    end
    def bounding_dates
      dates = []

      time_tables.each do |tm|
        dates << tm.start_date if tm.start_date
        dates << tm.end_date if tm.end_date
      end

      dates.empty? ? [] : [dates.min, dates.max]
    end

    def update_journey_pattern( selected_journey_pattern)
      return unless selected_journey_pattern.route_id==self.route_id

      missing_stops_in_relation_to_a_journey_pattern(selected_journey_pattern).each do |sp|
        self.vehicle_journey_at_stops.build( :stop_point => sp)
      end
      extra_vjas_in_relation_to_a_journey_pattern(selected_journey_pattern).each do |vjas|
        vjas._destroy = true
      end
    end

    def self.matrix(vehicle_journeys)
      {}.tap do |hash|
        vehicle_journeys.map{ |vj|
          vj.vehicle_journey_at_stops.map{ |vjas |hash[ "#{vj.id}-#{vjas.stop_point_id}"] = vjas }
        }
      end
    end

  end
end
