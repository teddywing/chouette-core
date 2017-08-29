class Import < ActiveRecord::Base
  mount_uploader :file, ImportUploader
  belongs_to :workbench
  belongs_to :referential

  belongs_to :parent, polymorphic: true

  has_many :messages, class_name: "ImportMessage"
  has_many :children, foreign_key: :parent_id, class_name: "Import"

  extend Enumerize
  enumerize :status, in: %i(new pending successful failed running aborted canceled)

  validates :file, presence: true
  validates_presence_of :workbench, :creator

  before_create :initialize_fields

  def self.model_name
    ActiveModel::Name.new Import, Import, "Import"
  end

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

  def child_change
    return if self.class.finished_statuses.include?(status)

    update_status
    update_referential
  end

  def update_status
    status_count = children.group(:status).count
    children_finished_count = children_failed_count = children_count = 0

    status_count.each do |status, count|
      if self.class.failing_statuses.include?(status)
        children_failed_count += count
      end
      if self.class.finished_statuses.include?(status)
        children_finished_count += count
      end
      children_count += count
    end

    attributes = {
      current_step: children_finished_count
    }

    status = self.status
    if children_failed_count > 0
      status = 'failed'
      # TODO: Update `ended_at`
    elsif status_count['successful'] == children_count
      status = 'successful'
      attributes[:ended_at] = Time.now
    end

    update attributes.merge(status: status)
  end

  def update_referential
    referential.update(ready: true) if self.class.finished_statuses.include?(status)
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
