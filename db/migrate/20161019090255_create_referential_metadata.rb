class CreateReferentialMetadata < ActiveRecord::Migration
  def change
    create_table :referential_metadata do |t|
      t.references :referential, index: true
      t.daterange :periode
      t.integer :line_ids, array: true
      t.index :line_ids, using: :gin
      t.references :referential_source, index: true

      t.timestamps
    end
  end
end
