class Import < ActiveRecord::Base
  mount_uploader :file, ImportUploader
  belongs_to :workbench
  belongs_to :referential

  belongs_to :parent, polymorphic: true

  extend Enumerize
  enumerize :status, in: %i(new pending successful failed running aborted canceled)

  validates :file, presence: true
  validates_presence_of :referential, :workbench

  before_create :initialize_fields

  def notify_parent
    parent.child_change(self)
  end

  def child_change(child)
    if failing_statuses.include?(child.status)
     return update(status: 'failed')
    end

    return update(status: 'successful') if ready?
  end

  def ready?
    current_step == total_steps
  end

  private

  def initialize_fields
    self.token_download = SecureRandom.urlsafe_base64
    self.status = Import.status.new
  end

  def failing_statuses
    %i(failed aborted canceled).flat_map { |status| [status, status.to_s] }
  end
end
