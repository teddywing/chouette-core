class AddMessageToLineSyncOperation < ActiveRecord::Migration
  def change
    add_column :line_sync_operations, :message, :string
  end
end
