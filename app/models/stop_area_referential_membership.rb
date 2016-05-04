class StopAreaReferentialMembership < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :stop_area_referential
end
