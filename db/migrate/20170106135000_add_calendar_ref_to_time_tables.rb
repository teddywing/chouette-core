class AddCalendarRefToTimeTables < ActiveRecord::Migration
  def change
    add_reference :time_tables, :calendar, index: true
  end
end
