class AddSeasonalToLines < ActiveRecord::Migration
  def change
    add_column :lines, :seasonal, :boolean
  end
end
