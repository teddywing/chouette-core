class AddExcludedDatesToCalendars < ActiveRecord::Migration
  def change
    add_column :calendars, :excluded_dates, :date, array: true
  end
end
