class StopAreaReferentialMembership < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :stop_area_referential

  validates :organisation_id, presence: true, uniqueness: { scope: :stop_area_referential }
end
