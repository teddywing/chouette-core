class AddDeletedAtToStopAreas < ActiveRecord::Migration
  def change
    add_column :stop_areas, :deleted_at, :datetime
  end
end
