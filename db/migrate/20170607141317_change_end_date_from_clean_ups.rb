class ChangeEndDateFromCleanUps < ActiveRecord::Migration
  def up
    change_column :clean_ups, :end_date, :date
  end

  def down
    change_column :clean_ups, :end_date, :datetime
  end
end
