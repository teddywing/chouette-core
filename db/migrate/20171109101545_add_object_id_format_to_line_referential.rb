class AddObjectIdFormatToLineReferential < ActiveRecord::Migration
  def change
    add_column :line_referentials, :objectid_format, :string unless column_exists? :line_referentials, :objectid_format
  end
end
