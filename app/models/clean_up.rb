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
    {}.tap do |result|
      result['time_table']        = send("destroy_time_tables_#{self.date_type}").try(:count)
      result['time_table_date']   = send("destroy_time_tables_dates_#{self.date_type}").try(:count)
      result['time_table_period'] = send("destroy_time_tables_periods_#{self.date_type}").try(:count)
    end
  end

  def destroy_time_tables_between
    time_tables = Chouette::TimeTable.where('end_date <= ? AND start_date >= ?', self.end_date, self.begin_date)
    self.destroy_time_tables(time_tables)
  end

  def destroy_time_tables_before
    time_tables = Chouette::TimeTable.where('end_date <= ?', self.begin_date)
    self.destroy_time_tables(time_tables)
  end

  def destroy_time_tables_after
    time_tables = Chouette::TimeTable.where('start_date >= ?', self.begin_date)
    self.destroy_time_tables(time_tables)
  end

  def destroy_time_table_dates_before
    Chouette::TimeTableDate.in_dates.where('date <= ?', self.begin_date).destroy_all
  end

  def destroy_time_tables_dates_after
    Chouette::TimeTableDate.in_dates.where('date >= ?', self.begin_date).destroy_all
  end

  def destroy_time_tables_dates_between
    Chouette::TimeTableDate.in_dates.where('date >= ? AND date <= ?', self.begin_date, self.end_date).destroy_all
  end

  def destroy_time_tables_periods_before
    Chouette::TimeTablePeriod.where('period_end <= ?', self.begin_date).destroy_all
  end

  def destroy_time_tables_periods_after
    Chouette::TimeTablePeriod.where('period_start >= ?', self.begin_date).destroy_all
  end

  def destroy_time_tables_periods_between
    Chouette::TimeTablePeriod.where('period_start >= ? AND period_end <= ?', self.begin_date, self.end_date).destroy_all
  end

  def destroy_time_tables(time_tables)
    time_tables.each do |time_table|
      time_table.vehicle_journeys.map(&:destroy)
    end
    time_tables.destroy_all
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
    CleanUpResult.create(destroy_up: self, message_key: :successfull, message_attributs: message_attributs)
  end

  def log_failed message_attributs
    update_attribute(:ended_at, Time.now)
    CleanUpResult.create(destroy_up: self, message_key: :failed, message_attributs: message_attributs)
  end
end
