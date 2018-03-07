class Export::Base < ActiveRecord::Base
  self.table_name = "exports"

  def self.messages_class_name
    "Export::Message"
  end

  def self.resources_class_name
    "Export::Resource"
  end

  include IevInterfaces::Task

  def self.model_name
    ActiveModel::Name.new Export::Base, Export::Base, "Export::Base"
  end

  private

  def initialize_fields
    super
    self.token_upload = SecureRandom.urlsafe_base64
  end

end
