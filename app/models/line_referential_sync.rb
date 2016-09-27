class LineReferentialSync < ActiveRecord::Base
  include AASM
  belongs_to :line_referential
  after_commit :perform_sync, :on => :create
  validate :multiple_process_validation, :on => :create

  private
  def perform_sync
    LineReferentialSyncWorker.perform_async(self.id)
  end

  # There can be only one instance running
  def multiple_process_validation
    if self.class.where(status: [:new, :pending], line_referential_id: line_referential_id).count > 0
      errors.add(:base, :multiple_process)
    end
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
      transitions :from => :pending, :to => :successful
    end

    event :failed, after: :log_failed do
      transitions :from => :pending, :to => :failed
    end
  end

  def log_pending
    logger.debug "#{self.class.name} sync - pending"
    update_attribute(:started_at, Time.now)
  end

  def log_successful
    logger.debug "#{self.class.name} sync - done"
  end

  def log_failed error
    logger.debug e.message
    logger.debug "#{self.class.name} sync - failed"
  end
end
