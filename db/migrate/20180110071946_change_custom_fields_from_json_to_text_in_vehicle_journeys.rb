class ChangeCustomFieldsFromJsonToTextInVehicleJourneys < ActiveRecord::Migration
  def change
    change_column :vehicle_journeys, :custom_field_values, :jsonb
  end
end
