class AddObjectIdFormatToReferential < ActiveRecord::Migration
  def change
    add_column :referentials, :objectid_format, :string
  end
end
