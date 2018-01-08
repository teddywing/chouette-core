class Workgroup < ActiveRecord::Base
  belongs_to :stop_area_referential
  belongs_to :line_referential

end
