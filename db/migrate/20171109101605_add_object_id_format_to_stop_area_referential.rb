class AddObjectIdFormatToStopAreaReferential < ActiveRecord::Migration
  def change
    add_column :stop_area_referentials, :objectid_format, :string unless column_exists? :stop_area_referentials, :objectid_format
  end
end
