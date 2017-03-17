class RemoveStopPointsRouteFk < ActiveRecord::Migration
  def change
    remove_foreign_key :stop_points, name: :stoppoint_route_fkey
  end
end
