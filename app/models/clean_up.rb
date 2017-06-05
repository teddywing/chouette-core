class CleanUp < ActiveRecord::Base
  extend Enumerize
  include AASM
  belongs_to :referential
  has_one :clean_up_result

  enumerize :date_type, in: %i(between before after)

  validates :begin_date, presence: true
  validates :date_type, presence: true
  after_commit :perform_cleanup, :on => :create

  def perform_cleanup
    CleanUpWorker.perform_async(self.id)
  end

  def clean
    result = {}
    result['time_table_count']      = self.clean_time_tables
    result['vehicle_journey_count'] = self.clean_vehicle_journeys
    result['journey_pattern_count'] = self.clean_journey_patterns
    result
  end

  def clean_time_tables
    Chouette::TimeTable.validity_out_between?(begin_date, end_date).delete_all
  end

  def clean_vehicle_journeys
    ids = Chouette::VehicleJourney.includes(:time_tables).where(:time_tables => {id: nil}).pluck(:id)
    Chouette::VehicleJourney.where(id: ids).delete_all
  end

  def clean_journey_patterns
    ids = Chouette::JourneyPattern.includes(:vehicle_journeys).where(:vehicle_journeys => {id: nil}).pluck(:id)
    Chouette::JourneyPattern.where(id: ids).delete_all
  end

  aasm column: :status do
    state :new, :initial => true
    state :pending
    state :successful
    state :failed

    event :run, after: :log_pending do
      transitions :from => [:new, :failed], :to => :pending
    end

    event :successful, after: :log_successful do
      transitions :from => [:pending, :failed], :to => :successful
    end

    event :failed, after: :log_failed do
      transitions :from => :pending, :to => :failed
    end
  end

  def log_pending
    update_attribute(:started_at, Time.now)
  end

  def log_successful message_attributs
    update_attribute(:ended_at, Time.now)
    CleanUpResult.create(clean_up: self, message_key: :successfull, message_attributs: message_attributs)
  end

  def log_failed message_attributs
    update_attribute(:ended_at, Time.now)
    CleanUpResult.create(clean_up: self, message_key: :failed, message_attributs: message_attributs)
  end
end
