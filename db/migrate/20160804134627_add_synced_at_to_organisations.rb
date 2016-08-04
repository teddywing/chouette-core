class AddSyncedAtToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :synced_at, :datetime
  end
end
