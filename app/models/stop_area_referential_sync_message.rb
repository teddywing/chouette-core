class StopAreaReferentialSyncMessage < ActiveRecord::Base
  belongs_to :stop_area_referential_sync
  enum criticity: [:info, :warning, :danger]

  validates :criticity, presence: true
end
