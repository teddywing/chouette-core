class CleanUp < ActiveRecord::Base
  include AASM
  belongs_to :referential
  validates :expected_date, presence: true
  after_commit :perform_cleanup, :on => :create

  def perform_cleanup
    CleanUpWorker.perform_async(self.id)
  end

  aasm column: :status do
    state :new, :initial => true
    state :pending
    state :successful
    state :failed

    event :run, after: :update_started_at do
      transitions :from => [:new, :failed], :to => :pending
    end

    event :successful, after: :update_ended_at do
      transitions :from => [:pending, :failed], :to => :successful
    end

    event :failed, after: :update_ended_at do
      transitions :from => :pending, :to => :failed
    end
  end

  def update_started_at
    update_attribute(:started_at, Time.now)
  end

  def update_ended_at
    update_attribute(:ended_at, Time.now)
  end

  def clean
    # as foreign keys are presents , delete method can be used for faster performance
    # find and remove time_tables
    result = CleanUpResult.new
    tms = Chouette::TimeTable.validity_out_from_on?(expected_date)
    result.time_table_count = tms.size
    tms.each.map(&:delete)

    result.vehicle_journey_count = self.clean_vehicle_journeys
    result.journey_pattern_count = self.clean_journey_patterns
    result.route_count           = self.clean_routes
    result.line_count            = self.clean_lines unless keep_lines

    unless keep_stops
      result.stop_count += self.clean_physical_stop_areas
      result.stop_count += self.clean_commercial_stop_areas
      result.stop_count += self.clean_stop_place_stop_areas
      result.stop_count += self.clean_itl_stop_areas
    end

    # If asked remove companies without lines or vehicle journeys
    result.company_count       = self.clean_companies unless keep_companies
    # If asked remove networks without lines
    result.network_count       = self.clean_networks unless keep_networks
    # If asked remove group_of_lines without lines
    result.group_of_line_count = self.clean_group_of_lines unless keep_group_of_lines
    result
  end

  def clean_physical_stop_areas
    ids = Chouette::StopArea.physical.includes(:stop_points).where(:stop_points => {id: nil}).pluck(:id)
    Chouette::StopArea.physical.where(id: ids).delete_all
  end

  def clean_commercial_stop_areas
    ids = Chouette::StopArea.commercial.where.not(parent_id: nil).pluck(:parent_id)
    Chouette::StopArea.commercial.where.not(id: ids).delete_all
  end

  def clean_stop_place_stop_areas
    ids = Chouette::StopArea.stop_place.includes(:stop_points).where(:stop_points => {id: nil}).pluck(:id)
    Chouette::StopArea.stop_place.where(id: ids).delete_all
  end

  def clean_itl_stop_areas
    ids = Chouette::StopArea.itl.includes(:stop_points).where(:stop_points => {id: nil}).pluck(:id)
    Chouette::StopArea.itl.where(id: ids).delete_all
  end

  def clean_vehicle_journeys
    ids = Chouette::VehicleJourney.includes(:time_tables).where(:time_tables => {id: nil}).pluck(:id)
    Chouette::VehicleJourney.where(id: ids).delete_all
  end

  def clean_lines
    ids = Chouette::Line.includes(:routes).where(:routes => {id: nil}).pluck(:id)
    Chouette::Line.where(id: ids).delete_all
  end

  def clean_routes
    ids = Chouette::Route.includes(:journey_patterns).where(:journey_patterns => {id: nil}).pluck(:id)
    Chouette::Route.where(id: ids).delete_all
  end

  def clean_journey_patterns
    ids = Chouette::JourneyPattern.includes(:vehicle_journeys).where(:vehicle_journeys => {id: nil}).pluck(:id)
    Chouette::JourneyPattern.where(id: ids).delete_all
  end

  def clean_companies
    ids = Chouette::Company.includes(:lines).where(:lines => {id: nil}).pluck(:id)
    Chouette::Company.where(id: ids).delete_all
  end

  def clean_networks
    ids = Chouette::Network.includes(:lines).where(:lines => {id: nil}).pluck(:id)
    Chouette::Network.where(id: ids).delete_all
  end

  def clean_group_of_lines
    ids = Chouette::GroupOfLine.includes(:lines).where(:lines => {id: nil}).pluck(:id)
    Chouette::GroupOfLine.where(id: ids).delete_all
  end
end
