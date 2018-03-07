class Import::Base < ActiveRecord::Base
  self.table_name = "imports"

  def self.messages_class_name
    "Import::Message"
  end

  def self.resources_class_name
    "Import::Resource"
  end

  include IevInterfaces::Task

  mount_uploader :file, ImportUploader

  has_many :children, foreign_key: :parent_id, class_name: "Import::Base", dependent: :destroy

  validates :file, presence: true

  before_create :initialize_fields

  def self.model_name
    ActiveModel::Name.new Import::Base, Import::Base, "Import::Base"
  end

  def children_succeedeed
    children.with_status(:successful, :warning).count
  end

  def child_change
    return if self.class.finished_statuses.include?(status)

    update_status
    update_referentials
  end

  def update_status
    status =
      if children.where(status: self.class.failed_statuses).count > 0
        'failed'
      elsif children.where(status: "warning").count > 0
        'warning'
      elsif children.where(status: "successful").count == children.count
        'successful'
      end

    attributes = {
      current_step: children.count,
      status: status
    }

    if self.class.finished_statuses.include?(status)
      attributes[:ended_at] = Time.now
    end

    update attributes
  end

  def update_referentials
    return unless self.class.finished_statuses.include?(status)

    children.each do |import|
      import.referential.update(ready: true) if import.referential
    end
  end

  private

  def initialize_fields
    self.token_download = SecureRandom.urlsafe_base64
  end

end
