class AddSyncedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :synced_at, :datetime
  end
end
