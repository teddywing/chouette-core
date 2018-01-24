class AddIntDayTypesToCalendars < ActiveRecord::Migration
  def change
    add_column :calendars, :int_day_types, :integer, default: 0
  end
end
