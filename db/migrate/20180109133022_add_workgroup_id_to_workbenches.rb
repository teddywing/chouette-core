class AddWorkgroupIdToWorkbenches < ActiveRecord::Migration
  def change
    add_column :workbenches, :workgroup_id, :integer, limit: 8
    add_index :workbenches, :workgroup_id
  end
end
