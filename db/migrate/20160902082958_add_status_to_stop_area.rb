class AddStatusToStopArea < ActiveRecord::Migration
  def change
    add_column :stop_areas, :status, :string
  end
end
