class Chouette::Line < Chouette::ActiveRecord
  include DefaultNetexAttributesSupport
  include LineRestrictions
  include LineReferentialSupport
  include StifTransportModeEnumerations

  extend Enumerize
  extend ActiveModel::Naming

  enumerize :transport_submode, in: %i(unknown undefined internationalFlight domesticFlight intercontinentalFlight domesticScheduledFlight shuttleFlight intercontinentalCharterFlight internationalCharterFlight roundTripCharterFlight sightseeingFlight helicopterService domesticCharterFlight SchengenAreaFlight airshipService shortHaulInternationalFlight canalBarge localBus regionalBus expressBus nightBus postBus specialNeedsBus mobilityBus mobilityBusForRegisteredDisabled sightseeingBus shuttleBus highFrequencyBus dedicatedLaneBus schoolBus schoolAndPublicServiceBus railReplacementBus demandAndResponseBus airportLinkBus internationalCoach nationalCoach shuttleCoach regionalCoach specialCoach schoolCoach sightseeingCoach touristCoach commuterCoach metro tube urbanRailway local highSpeedRail suburbanRailway regionalRail interregionalRail longDistance intermational sleeperRailService nightRail carTransportRailService touristRailway railShuttle replacementRailService specialTrain crossCountryRail rackAndPinionRailway cityTram localTram regionalTram sightseeingTram shuttleTram trainTram internationalCarFerry nationalCarFerry regionalCarFerry localCarFerry internationalPassengerFerry nationalPassengerFerry regionalPassengerFerry localPassengerFerry postBoat trainFerry roadFerryLink airportBoatLink highSpeedVehicleService highSpeedPassengerService sightseeingService schoolBoat cableFerry riverBus scheduledFerry shuttleFerryService telecabin cableCar lift chairLift dragLift telecabinLink funicular streetCableCar allFunicularServices undefinedFunicular)

  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  self.primary_key = "id"

  belongs_to :company
  belongs_to :network

  has_array_of :secondary_companies, class_name: 'Chouette::Company'

  has_many :routes, :dependent => :destroy
  has_many :journey_patterns, :through => :routes
  has_many :vehicle_journeys, :through => :journey_patterns

  has_and_belongs_to_many :group_of_lines, :class_name => 'Chouette::GroupOfLine', :order => 'group_of_lines.name'

  has_many :footnotes, :inverse_of => :line, :validate => :true, :dependent => :destroy
  accepts_nested_attributes_for :footnotes, :reject_if => :all_blank, :allow_destroy => true

  has_many :routing_constraint_zones

  attr_reader :group_of_line_tokens

  # validates_presence_of :network
  # validates_presence_of :company

  validates_format_of :registration_number, :with => %r{\A[\d\w_\-]+\Z}, :allow_nil => true, :allow_blank => true
  validates_format_of :stable_id, :with => %r{\A[\d\w_\-]+\Z}, :allow_nil => true, :allow_blank => true
  validates_format_of :url, :with => %r{\Ahttps?:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\Z}, :allow_nil => true, :allow_blank => true
  validates_format_of :color, :with => %r{\A[0-9a-fA-F]{6}\Z}, :allow_nil => true, :allow_blank => true
  validates_format_of :text_color, :with => %r{\A[0-9a-fA-F]{6}\Z}, :allow_nil => true, :allow_blank => true

  validates_presence_of :name

  scope :by_text, ->(text) { where('lower(name) LIKE :t or lower(published_name) LIKE :t or lower(objectid) LIKE :t or lower(comment) LIKE :t or lower(number) LIKE :t',
    t: "%#{text.downcase}%") }

  def self.nullable_attributes
    [:published_name, :number, :comment, :url, :color, :text_color, :stable_id]
  end

  def geometry_presenter
    Chouette::Geometry::LinePresenter.new self
  end

  def commercial_stop_areas
    Chouette::StopArea.joins(:children => [:stop_points => [:route => :line] ]).where(:lines => {:id => self.id}).uniq
  end

  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:route => :line]).where(:lines => {:id => self.id})
  end

  def stop_areas_last_parents
    Chouette::StopArea.joins(:stop_points => [:route => :line]).where(:lines => {:id => self.id}).collect(&:root).flatten.uniq
  end

  def group_of_line_tokens=(ids)
    self.group_of_line_ids = ids.split(",")
  end

  def vehicle_journey_frequencies?
    self.vehicle_journeys.unscoped.where(journey_category: 1).count > 0
  end

  def display_name
    [name, company.try(:name)].compact.join(' - ')
  end

end
