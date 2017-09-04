class ImportResource < ActiveRecord::Base
  belongs_to :import

  extend Enumerize
  enumerize :status, in: %i(OK ERROR WARNING IGNORED), scope: true

  validates_presence_of :name, :resource_type, :reference
  
end
