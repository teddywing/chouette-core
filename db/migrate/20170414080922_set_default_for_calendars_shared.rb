class SetDefaultForCalendarsShared < ActiveRecord::Migration
  def change
    change_column_default :calendars, :shared, :false
    Calendar.where(shared: nil).update_all(shared: false)
  end
end
