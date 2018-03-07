class Import::Message < ActiveRecord::Base
  self.table_name = :import_messages

  include IevInterfaces::Message

  belongs_to :import, class_name: Import::Base
  belongs_to :resource, class_name: Import::Resource
end
