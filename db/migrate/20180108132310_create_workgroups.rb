class CreateWorkgroups < ActiveRecord::Migration
  def change
    create_table :workgroups do |t|
      t.string :name
      t.integer :line_referential, index: true, limit: 8
      t.integer :stop_area_referential, index: true, limit: 8

      t.timestamps null: false
    end
  end
end
