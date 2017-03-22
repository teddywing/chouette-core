class RemoveStopPointsRouteFk < ActiveRecord::Migration
  def change
    if foreign_keys(:stop_points).include?(:stoppoint_route_fkey)
      remove_foreign_key :stop_points, name: :stoppoint_route_fkey
    end
  end
end
