class Import::Gtfs < Import::Base
  after_commit :launch_worker, :on => :create

  def launch_worker
    GtfsImportWorker.perform_async id
  end

  def import
    workbench_import.update(status: 'running', started_at: Time.now)

    import_without_status
    workbench_import.update(status: 'successful', ended_at: Time.now)
  rescue Exception => e
    workbench_import.update(status: 'failed', ended_at: Time.now)
    raise e
  end

  attr_accessor :local_file

  # TODO download the imported file
  # def local_file
  #   @local_file
  # end

  # TODO create referential with metadatas
  # def referential
  # ...
  # end

  def source
    @source ||= ::GTFS::Source.build local_file
  end

  delegate :line_referential, :stop_area_referential, to: :referential

  def import_without_status
    referential.switch

    import_agencies
    import_stops
    import_routes
    import_trips
    import_stop_times
  end

  def import_agencies
    source.agencies.each do |agency|
      company = line_referential.companies.find_or_initialize_by(registration_number: agency.id)
      company.attributes = { name: agency.name }

      save company
    end
  end

  def import_stops
    source.stops.each do |stop|
      stop_area = stop_area_referential.stop_areas.find_or_initialize_by(registration_number: stop.id)

      stop_area.name = stop.name
      stop_area.area_type = stop.location_type == "1" ? "zdlp" : "zdep"
      stop_area.parent = stop_referential.stop_areas.find_by!(registration_number: stop.parent_station) if stop.parent_station.present?
      stop_area.latitude, stop_area.longitude = stop.lat, stop.lon
      stop_area.kind = "commercial"

      # TODO correct default timezone

      save stop_area
    end
  end

  def import_routes
    source.routes.each do |route|
      line = line_referential.lines.find_or_initialize_by(registration_number: route.id)
      line.name = route.long_name.presence || route.short_name
      line.number = route.short_name
      line.published_name = route.long_name

      line.company = line_referential.companies.find_by(registration_number: route.agency_id) if route.agency_id.present?

      # TODO transport mode

      line.comment = route.desc

      # TODO colors

      line.url = route.url

      save line
    end
  end

  def vehicle_journey_by_trip_id
    @vehicle_journey_by_trip_id ||= {}
  end

  def import_trips
    source.trips.each do |trip|
      line = line_referential.lines.find_by registration_number: trip.route_id

      route = referential.routes.build line: line
      route.wayback = (trip.direction_id == "0" ? :outbound : :inbound)
      # TODO better name ?
      name = route.published_name = trip.short_name.presence || trip.headsign.presence || route.wayback.to_s.capitalize
      route.name = name
      save route

      journey_pattern = route.journey_patterns.build name: name
      save journey_pattern

      vehicle_journey = journey_pattern.vehicle_journeys.build route: route
      vehicle_journey.published_journey_name = trip.headsign.presence || trip.id
      save vehicle_journey

      vehicle_journey_by_trip_id[trip.id] = vehicle_journey.id
    end
  end

  def import_stop_times
    source.stop_times.group_by(&:trip_id).each do |trip_id, stop_times|
      vehicle_journey = referential.vehicle_journeys.find vehicle_journey_by_trip_id[trip_id]
      journey_pattern = vehicle_journey.journey_pattern
      route = journey_pattern.route

      stop_times.sort_by!(&:stop_sequence)

      stop_times.each do |stop_time|
        stop_area = stop_area_referential.stop_areas.find_by(registration_number: stop_time.stop_id)

        stop_point = route.stop_points.build stop_area: stop_area
        save stop_point

        journey_pattern.stop_points << stop_point

        # JourneyPattern#vjas_add creates automaticaly VehicleJourneyAtStop
        vehicle_journey_at_stop = journey_pattern.vehicle_journey_at_stops.find_by(stop_point_id: stop_point.id)
        vehicle_journey_at_stop.departure_time = stop_time.departure_time
        vehicle_journey_at_stop.arrival_time = stop_time.arrival_time

        # TODO offset

        save vehicle_journey_at_stop
      end
    end
  end

  def save(model)
    unless model.save
      Rails.logger.info "Can't save #{model.class.name} : #{model.errors.inspect}"
      raise ActiveRecord::RecordNotSaved.new("Invalid #{model.class.name}")
    end
    Rails.logger.debug "Created #{model.inspect}"
  end

end
