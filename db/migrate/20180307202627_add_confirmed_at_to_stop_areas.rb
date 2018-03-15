class AddConfirmedAtToStopAreas < ActiveRecord::Migration
  def change
    add_column :stop_areas, :confirmed_at, :datetime
  end
end
