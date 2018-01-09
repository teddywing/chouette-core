class CustomField < ActiveRecord::Base

  extend Enumerize
  enumerize :field_type, in: %i{list} 

  validates :name, uniqueness: {scope: :resource_type}
end
