class ReferentialSuite < ActiveRecord::Base
  belongs_to :new, class_name: 'Referential'
  belongs_to :current, class_name: 'Referential'
end
