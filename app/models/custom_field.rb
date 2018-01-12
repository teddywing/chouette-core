class CustomField < ActiveRecord::Base

  extend Enumerize
  enumerize :field_type, in: %i{list}

  validates :name, uniqueness: {scope: :resource_type}
  validates :code, uniqueness: {scope: :resource_type, case_sensitive: false}
end
