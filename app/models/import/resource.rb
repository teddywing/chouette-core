class Import::Resource < ActiveRecord::Base
  self.table_name = :import_resources

  include IevInterfaces::Resource

  belongs_to :import, class_name: Import::Base
  has_many :messages, class_name: "ImportMessage", foreign_key: :resource_id
end
