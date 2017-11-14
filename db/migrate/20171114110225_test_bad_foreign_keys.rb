class TestBadForeignKeys < ActiveRecord::Migration
  def change
    create_table :bad_foreign_keys do |t|
      t.string :thing
      t.references :forei
      t.integer :quant
      t.references :anoth_for

      t.timestamps null: false
    end
  end
end
