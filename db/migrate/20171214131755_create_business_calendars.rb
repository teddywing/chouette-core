class CreateBusinessCalendars < ActiveRecord::Migration
  def change
    create_table :business_calendars do |t|
      t.string :name
      t.string :short_name
      t.string :color
      t.date :dates
      t.daterange :date_ranges

      t.timestamps null: false
    end
  end
end
