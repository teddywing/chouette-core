class RenameColumnexpectedDateFromCleanups < ActiveRecord::Migration
  def up
    rename_column :clean_ups, :expected_date, :begin_date
  end

  def down
    rename_column :clean_ups, :begin_date, :expected_date
  end
end
