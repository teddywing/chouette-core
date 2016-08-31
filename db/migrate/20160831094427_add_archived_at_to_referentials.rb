class AddArchivedAtToReferentials < ActiveRecord::Migration
  def change
    add_column :referentials, :archived_at, :datetime
  end
end
