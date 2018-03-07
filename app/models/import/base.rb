class Import::Base < ActiveRecord::Base
  self.table_name = "imports"
  validates :file, presence: true

  def self.messages_class_name
    "Import::Message"
  end

  def self.resources_class_name
    "Import::Resource"
  end

  include IevInterfaces::Task

  def self.model_name
    ActiveModel::Name.new Import::Base, Import::Base, "Import"
  end

  def child_change
    return if self.class.finished_statuses.include?(status)

    super
    update_referentials
  end

  def update_referentials
    return unless self.class.finished_statuses.include?(status)

    children.each do |import|
      import.referential.update(ready: true) if import.referential
    end
  end

  private

  def initialize_fields
    super
    self.token_download = SecureRandom.urlsafe_base64
  end

end
