class RenameTransportModeName < ActiveRecord::Migration
  def change
    rename_column :lines, :transport_mode_name, :transport_mode
  end
end
