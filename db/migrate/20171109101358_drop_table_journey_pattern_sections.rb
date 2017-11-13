class DropTableJourneyPatternSections < ActiveRecord::Migration
  def change
    drop_table :journey_pattern_sections
  end
end
