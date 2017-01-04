class CreateRoutingConstraintZones < ActiveRecord::Migration
  def up
    unless table_exists? :routing_constraint_zones
      create_table :routing_constraint_zones do |t|
        t.string :name
        t.integer :stop_area_ids, array: true
        t.belongs_to :line, index: true

        t.timestamps
      end
    end
  end

  def down
    if table_exists? :routing_constraint_zones
      drop_table :routing_constraint_zones
    end
  end
end
