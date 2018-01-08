class AddCostsToJourneyPatterns < ActiveRecord::Migration
  def change
    add_column :journey_patterns, :costs, :json
  end
end
