class AddTridentFieldsToRoutingConstraintZone < ActiveRecord::Migration
  def change
    add_column :routing_constraint_zones, :objectid, :string, null: false
    add_column :routing_constraint_zones, :object_version, :integer
  end
end
