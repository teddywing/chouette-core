class ChangeItemIdInVersionsToBigint < ActiveRecord::Migration
  def up
    change_column :versions, :item_id, :integer, limit: 8, null: false
  end
  def down
    change_column :versions, :item_id, :integer, null: false
  end
end
