class ModelAttribute
  cattr_reader :all

  @@all = []

  attr_reader :klass, :name, :data_type

  def self.define(klass, name, data_type)
    @@all << new(klass, name, data_type)
  end

  def initialize(klass, name, data_type)
    @klass = klass
    @name = name
    @data_type = data_type
  end

  # Chouette::Route
  define :route, :name, :string
  define :route, :published_name, :string
  define :route, :comment, :string
  define :route, :number, :string
  define :route, :direction, :string
  define :route, :wayback, :string

  # Chouette::JourneyPattern
  define :journey_pattern, :name, :string
  define :journey_pattern, :published_name, :string
  define :journey_pattern, :comment, :string
  define :journey_pattern, :registration_number, :string
  define :journey_pattern, :section_status, :integer

  # Chouette::VehicleJourney
  define :vehicle_journey, :comment, :string
  define :vehicle_journey, :status_value, :string
  define :vehicle_journey, :transport_mode, :string
  define :vehicle_journey, :facility, :string
  define :vehicle_journey, :published_journey_name, :string
  define :vehicle_journey, :published_journey_identifier, :string
  define :vehicle_journey, :vehicle_type_identifier, :string
  define :vehicle_journey, :number, :integer
  define :vehicle_journey, :mobility_restricted_suitability, :boolean
  define :vehicle_journey, :flexible_service, :boolean

  # Chouette::Footnote
  define :footnote, :code, :string
  define :footnote, :label, :string

  # Chouette::TimeTable
  define :time_table, :version, :string
  define :time_table, :comment, :string
  define :time_table, :start_date, :date
  define :time_table, :end_date, :date
  define :time_table, :color, :string

  # Chouette::RoutingConstraintZone
  define :routing_constraint_zone, :name, :string
end
