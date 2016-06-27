class LineReferentialSync < ActiveRecord::Base
  belongs_to :line_referential

  has_many :line_sync_operations, dependent: :destroy

  def record_status status
    line_sync_operations << LineSyncOperation.new(status: status)
    line_sync_operations.first.destroy while line_sync_operations.count > 30
  end
end
