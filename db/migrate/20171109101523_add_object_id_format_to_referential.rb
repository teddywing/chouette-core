class AddObjectIdFormatToReferential < ActiveRecord::Migration
  def change
    add_column :referentials, :objectid_format, :string unless column_exists? :referentials, :objectid_format
  end
end
