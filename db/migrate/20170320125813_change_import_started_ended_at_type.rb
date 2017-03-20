class ChangeImportStartedEndedAtType < ActiveRecord::Migration
  def change
    change_column :imports, :started_at, :datetime
    change_column :imports, :ended_at, :datetime
  end
end
