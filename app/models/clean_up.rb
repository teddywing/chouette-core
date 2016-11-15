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
    result = CleanUpResult.new
    tms = Chouette::TimeTable.validity_out_from_on?(expected_date)
    result.time_table_count = tms.size
    tms.each.map(&:delete)

    result.vehicle_journey_count = self.clean_vehicle_journeys
    result.journey_pattern_count = self.clean_journey_patterns
    result
  end

  def clean_vehicle_journeys
    ids = Chouette::VehicleJourney.includes(:time_tables).where(:time_tables => {id: nil}).pluck(:id)
    Chouette::VehicleJourney.where(id: ids).delete_all
  end

  def clean_journey_patterns
    ids = Chouette::JourneyPattern.includes(:vehicle_journeys).where(:vehicle_journeys => {id: nil}).pluck(:id)
    Chouette::JourneyPattern.where(id: ids).delete_all
  end
end
