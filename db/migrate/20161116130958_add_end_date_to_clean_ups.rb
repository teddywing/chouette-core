class AddEndDateToCleanUps < ActiveRecord::Migration
  def change
    add_column :clean_ups, :end_date, :datetime
  end
end
