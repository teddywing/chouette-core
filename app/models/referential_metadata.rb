class ReferentialMetadata < ActiveRecord::Base
  belongs_to :referential
  belongs_to :referential_source, class_name: 'Referential'

  has_array_of :lines, class_name: 'Chouette::Line'
end
