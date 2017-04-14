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
      at_stops = self.vehicle_journey_at_stops.to_a.dup
      (route.stop_points.map(&:id) - at_stops.map(&:stop_point_id)).each do |id|
        # Set stop_point id for fake vjas with no departure time yep.
        params = {}
        params[:stop_point_id] = id if journey_pattern.stop_points.map(&:id).include?(id)
        at_stops.insert(route.stop_points.map(&:id).index(id), Chouette::VehicleJourneyAtStop.new(params))
      end
      at_stops
    end

    def create_or_find_vjas_from_state vjas
      return vehicle_journey_at_stops.find(vjas['id']) if vjas['id']
      stop_point = Chouette::StopPoint.find_by(objectid: vjas['stop_point_objectid'])
      stop       = vehicle_journey_at_stops.create(stop_point: stop_point)
      vjas['id'] = stop.id
      vjas['new_record'] = true
      stop
    end

    def update_vjas_from_state state
      state.each do |vjas|
        next if vjas["dummy"]
        params = {}.tap do |el|
          ['arrival_time', 'departure_time'].each do |field|
            time = "#{vjas[field]['hour']}:#{vjas[field]['minute']}"
            el[field.to_sym] = Time.parse("2000-01-01 #{time}:00 UTC")
          end
        end
        stop = create_or_find_vjas_from_state(vjas)
        stop.update_attributes(params)
        vjas.delete('errors')
        vjas['errors'] = stop.errors if stop.errors.any?
      end
    end

    def state_update_vjas? vehicle_journey_at_stops
      departure_times = vehicle_journey_at_stops.map do |vjas|
        "#{vjas['departure_time']['hour']}:#{vjas['departure_time']['minute']}"
      end
      times = departure_times.uniq
      (times.count == 1 && times[0] == '00:00') ? false : true
    end

    def update_has_and_belongs_to_many_from_state item
      ['time_tables', 'footnotes'].each do |assos|
        saved = self.send(assos).map(&:id)

        (saved - item[assos].map{|t| t['id']}).each do |id|
          self.send(assos).delete(self.send(assos).find(id))
        end

        item[assos].each do |t|
          klass = "Chouette::#{assos.classify}".constantize
          unless saved.include?(t['id'])
            self.send(assos) << klass.find(t['id'])
          end
        end
      end
    end

    def self.state_update route, state
      transaction do
        state.each do |item|
          item.delete('errors')
          vj = find_by(objectid: item['objectid']) || state_create_instance(route, item)
          next if item['deletable'] && vj.persisted? && vj.destroy

          if vj.state_update_vjas?(item['vehicle_journey_at_stops'])
            vj.update_vjas_from_state(item['vehicle_journey_at_stops'])
          end

          vj.update_attributes(state_permited_attributes(item))
          vj.update_has_and_belongs_to_many_from_state(item)
          item['errors'] = vj.errors if vj.errors.any?
        end

        # Delete ids of new object from state if we had to rollback
        if state.any? {|item| item['errors']}
          state.map do |item|
            item.delete('objectid') if item['new_record']
            item['vehicle_journey_at_stops'].map {|vjas| vjas.delete('id') if vjas['new_record'] }
          end
          raise ::ActiveRecord::Rollback
        end
      end

      # Remove new_record flag && deleted item from state if transaction has been saved
      state.map do |item|
        item.delete('new_record')
        item['vehicle_journey_at_stops'].map {|vjas| vjas.delete('new_record') }
      end
      state.delete_if {|item| item['deletable']}
    end

    def self.state_create_instance route, item
      # Flag new record, so we can unset object_id if transaction rollback
      vj = route.vehicle_journeys.create(state_permited_attributes(item))
      item['objectid']   = vj.objectid
      item['new_record'] = true
      vj
    end

    def self.state_permited_attributes item
      attrs = item.slice('published_journey_identifier', 'published_journey_name', 'journey_pattern_id', 'company_id').to_hash
      ['company', 'journey_pattern'].map do |association|
        attrs["#{association}_id"] = item[association]['id'] if item[association]
      end
      attrs
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
