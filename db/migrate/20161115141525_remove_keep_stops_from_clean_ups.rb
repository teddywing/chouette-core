class RemoveKeepStopsFromCleanUps < ActiveRecord::Migration
  def change
    remove_column :clean_ups, :keep_stops, :boolean
  end
end
