class CreateImports < ActiveRecord::Migration
  def change
    unless table_exists? :imports
      create_table :imports do |t|
        t.belongs_to :referential
        t.string :status

        t.timestamps
      end
      add_index :imports, :referential_id
    end
  end
end
