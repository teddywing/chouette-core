class SpringCleanup < ActiveRecord::Migration
  def change
    drop_table :timebands, :journey_frequencies, :vehicle_journey_frequencies, :access_points, :access_links
    drop_table :export_tasks
  end
end
