class Import < ActiveRecord::Base
  mount_uploader :file, ImportUploader
  belongs_to :workbench
  belongs_to :referential

  belongs_to :parent, polymorphic: true

  extend Enumerize
  enumerize :status, in: %i(new pending successful failed running aborted canceled)

  validates :file, presence: true
  validates_presence_of :workbench

  before_create :initialize_fields

  def self.failing_statuses
    symbols_with_indifferent_access(%i(failed aborted canceled))
  end

  def self.finished_statuses
    symbols_with_indifferent_access(%i(successful failed aborted canceled))
  end

  def notify_parent
    parent.child_change(self)
    update(notified_parent_at: DateTime.now)
  end

  def child_change(child)
    return if self.class.finished_statuses.include?(status)

    if self.class.failing_statuses.include?(child.status)
     return update(status: 'failed')
    end

    update(status: 'successful') if ready?
  end

  def ready?
    current_step == total_steps
  end

  private

  def initialize_fields
    self.token_download = SecureRandom.urlsafe_base64
    self.status = Import.status.new
  end

  def self.symbols_with_indifferent_access(array)
    array.flat_map { |symbol| [symbol, symbol.to_s] }
  end
end
