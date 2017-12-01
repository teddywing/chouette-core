class AddObjectIdFormatToWorkbenches < ActiveRecord::Migration
  def change
    add_column :workbenches, :objectid_format, :string unless column_exists? :workbenches, :objectid_format
  end
end
