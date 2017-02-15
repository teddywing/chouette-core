class AddSecondaryCompaniesToLines < ActiveRecord::Migration
  def change
    add_column :lines, :secondary_companies_ids, :integer, array: true
    add_index :lines, :secondary_companies_ids, using: :gin
  end
end
