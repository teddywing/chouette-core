class StopAreaReferentialSync < ActiveRecord::Base
  belongs_to :stop_area_referential
  has_many :stop_area_sync_operations, dependent: :destroy

  def record_status status, message
    stop_area_sync_operations << StopAreaSyncOperation.new(status: status, message: message)
    stop_area_sync_operations.first.destroy while stop_area_sync_operations.count > 30
  end
end
