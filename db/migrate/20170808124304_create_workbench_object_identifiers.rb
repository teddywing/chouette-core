class CreateWorkbenchObjectIdentifiers < ActiveRecord::Migration
  def change
    create_table :workbench_object_identifiers do |t|
      t.string :object_class
      t.integer :last_technical_id
      t.references :workbench, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
