class AddSyncIntervalToLineReferentials < ActiveRecord::Migration
  def change
    add_column :line_referentials, :sync_interval, :int, :default => 1
  end
end
