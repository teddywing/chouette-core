class AddCustomFieldValuesToJourneyPatterns < ActiveRecord::Migration
  def change
    add_column :journey_patterns, :custom_field_values, :jsonb
  end
end
