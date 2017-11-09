class AddObjectIdFormatToStopAreaReferential < ActiveRecord::Migration
  def change
    add_column :stop_area_referentials, :objectid_format, :string
  end
end
