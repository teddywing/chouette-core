class AddCreatedFromToTimeTables < ActiveRecord::Migration
  def change
    add_reference :time_tables, :created_from, index: true
  end
end
