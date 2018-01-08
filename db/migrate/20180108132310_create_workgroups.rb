class CreateWorkgroups < ActiveRecord::Migration
  def change
    create_table :workgroups do |t|
      t.string :name
      t.references :line_referential, index: true, foreign_key: true
      t.references :stop_area_referential, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
