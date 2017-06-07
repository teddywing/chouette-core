class ChangeBeginDateFromCleanUps < ActiveRecord::Migration
  def up
    change_column :clean_ups, :begin_date, :date
  end

  def down
    change_column :clean_ups, :begin_date, :datetime
  end
end
