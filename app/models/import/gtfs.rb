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
  def local_file
    @local_file ||= download_local_file
  end

  attr_accessor :download_host
  def download_host
    @download_host ||= Rails.application.config.rails_host.gsub("http://","")
  end

  def local_temp_directory
    Rails.application.config.try(:import_temporary_directory) ||
      Rails.root.join('tmp', 'imports')
  end

  def local_temp_file(&block)
    Tempfile.open "chouette-import", local_temp_directory, &block
  end

  def download_path
    Rails.application.routes.url_helpers.download_workbench_import_path(workbench, id, token: token_download)
  end

  def download_local_file
    local_temp_file do |file|
      begin
        Net::HTTP.start(download_host) do |http|
          http.request_get(download_path) do |response|
            response.read_body do |segment|
              file.write segment
            end
          end
        end
      ensure
        file.close
      end

      file.path
    end
  end

  def source
    @source ||= ::GTFS::Source.build local_file
  end

  delegate :line_referential, :stop_area_referential, to: :referential

  def import_without_status
    referential.switch

    import_agencies
    import_stops
    import_calandars

    import_routes
    import_trips
    import_stop_times
  end

  def import_agencies
    source.agencies.each do |agency|
      company = line_referential.companies.find_or_initialize_by(registration_number: agency.id)
      company.attributes = { name: agency.name }

      save_model company
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

      save_model stop_area
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

      save_model line
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
      save_model route

      journey_pattern = route.journey_patterns.build name: name
      save_model journey_pattern

      vehicle_journey = journey_pattern.vehicle_journeys.build route: route
      vehicle_journey.published_journey_name = trip.headsign.presence || trip.id
      save_model vehicle_journey

      vehicle_journey.time_tables << referential.time_tables.find(time_tables_by_service_id[trip.service_id])

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
        save_model stop_point

        journey_pattern.stop_points << stop_point

        # JourneyPattern#vjas_add creates automaticaly VehicleJourneyAtStop
        vehicle_journey_at_stop = journey_pattern.vehicle_journey_at_stops.find_by(stop_point_id: stop_point.id)
        vehicle_journey_at_stop.departure_time = stop_time.departure_time
        vehicle_journey_at_stop.arrival_time = stop_time.arrival_time

        # TODO offset

        save_model vehicle_journey_at_stop
      end
    end
  end

  def time_tables_by_service_id
    @time_tables_by_service_id ||= {}
  end

  def import_calendars
    source.calendars.each do |calendar|
      time_table = referential.time_tables.build comment: "Calendar #{calendar.service_id}"
      Chouette::TimeTable.all_days.each do |day|
        time_table.send("#{day}=", calendar.send(day))
      end
      time_table.periods.build period_start: calendar.start_date, period_end: calendar.end_date

      save_model time_table

      time_tables_by_service_id[calendar.service_id] = time_table.id
    end
  end

  def save_model(model)
    unless model.save
      Rails.logger.info "Can't save #{model.class.name} : #{model.errors.inspect}"
      raise ActiveRecord::RecordNotSaved.new("Invalid #{model.class.name}")
    end
    Rails.logger.debug "Created #{model.inspect}"
  end

end
