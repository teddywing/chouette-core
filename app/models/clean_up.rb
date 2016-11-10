class CleanUp
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :expected_date, :keep_lines, :keep_stops , :keep_companies
  attr_accessor :keep_networks, :keep_group_of_lines

  validates_presence_of :expected_date

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def physical_stop_areas
    Chouette::StopArea.physical.includes(:stop_points).where(:stop_points => {id: nil})
  end

  def clean_physical_stop_areas
     Chouette::StopArea.where(id: self.physical_stop_areas.pluck(:id)).delete_all
  end

  def commercial_stop_areas
    Chouette::StopArea.commercial
  end

  def stop_place_stop_areas
    Chouette::StopArea.stop_place
  end

  def itl_stop_areas
    Chouette::StopArea.itl
  end

  def vehicle_journeys
    Chouette::VehicleJourney.includes(:time_tables).where(:time_tables => {id: nil})
  end
  def clean_vehicle_journeys
    Chouette::VehicleJourney.where(id: self.vehicle_journeys.pluck(:id)).delete_all
  end

  def lines
    Chouette::Line.includes(:routes).where(:routes => {id: nil})
  end
  def clean_lines
    Chouette::Line.where(id: self.lines.pluck(:id)).delete_all
  end

  def routes
    Chouette::Route.includes(:journey_patterns).where(:journey_patterns => {id: nil})
  end
  def clean_routes
    Chouette::Route.where(id: self.routes.pluck(:id)).delete_all
  end

  def journey_patterns
    Chouette::JourneyPattern.includes(:vehicle_journeys).where(:vehicle_journeys => {id: nil})
  end
  def clean_journey_patterns
    Chouette::JourneyPattern.where(id: self.journey_patterns.pluck(:id)).delete_all
  end

  def clean
    # as foreign keys are presents , delete method can be used for faster performance
    result = CleanUpResult.new
    # find and remove time_tables
    tms = Chouette::TimeTable.validity_out_from_on?(Date.parse(expected_date))
    result.time_table_count = tms.size
    tms.each do |tm|
      tm.delete
    end

    result.vehicle_journey_count = self.clean_vehicle_journeys
    result.journey_pattern_count = self.clean_journey_patterns
    result.route_count           = self.clean_routes

    result.line_count = self.clean_lines if keep_lines == "0"
    result.stop_count = self.clean_physical_stop_areas if keep_stops == "0"

    if keep_stops == "0"
      commercial_stop_areas.find_each do |csp|
        if csp.children.size == 0
          result.stop_count += 1
          csp.delete
        end
      end
      stop_place_stop_areas.find_each do |sp|
        if sp.children.size == 0
          result.stop_count += 1
          sp.delete
        end
      end
      itl_stop_areas.find_each do |itl|
        if itl.routing_stops.size == 0
          result.stop_count += 1
          itl.delete
        end
      end
    end
    # if asked remove companies without lines or vehicle journeys
    if keep_companies == "0"
      Chouette::Company.find_each do |c|
        if c.lines.size == 0
          result.company_count += 1
          c.delete
        end
      end
    end

    # if asked remove networks without lines
    if keep_networks == "0"
      Chouette::Network.find_each do |n|
        if n.lines.size == 0
          result.network_count += 1
          n.delete
        end
      end
    end

    # if asked remove group_of_lines without lines
    if keep_group_of_lines == "0"
      Chouette::GroupOfLine.find_each do |n|
        if n.lines.size == 0
          result.group_of_line_count += 1
          n.delete
        end
      end
    end
    result
  end

end
