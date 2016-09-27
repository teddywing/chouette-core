class LineReferentialSync < ActiveRecord::Base
  belongs_to :line_referential
  after_create :perform_sync
  validate :multiple_process_validation, :on => :create

  private
  def perform_sync
    LineReferentialSyncWorker.perform_async(self.id)
  end

  # There can be only one instance running
  def multiple_process_validation
    if self.class.where(ended_at: nil, line_referential_id: line_referential_id).count > 0
      errors.add(:base, :multiple_process)
    end
  end
end
