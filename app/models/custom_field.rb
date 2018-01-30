class CustomField < ActiveRecord::Base

  extend Enumerize
  belongs_to :workgroup
  enumerize :field_type, in: %i{list}

  validates :name, uniqueness: {scope: [:resource_type, :workgroup_id]}
  validates :code, uniqueness: {scope: [:resource_type, :workgroup_id], case_sensitive: false}
end
