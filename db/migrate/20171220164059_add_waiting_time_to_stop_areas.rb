class AddWaitingTimeToStopAreas < ActiveRecord::Migration
  def change
    add_column :stop_areas, :waiting_time, :integer
  end
end
