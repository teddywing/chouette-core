class RenameBusinessCalendarsToPurchaseWindows < ActiveRecord::Migration
  def change
    rename_table :business_calendars, :purchase_windows
  end
end
