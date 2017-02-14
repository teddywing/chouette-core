class AddTimestampsToSomeModels < ActiveRecord::Migration
  def change
    models = %i(vehicle_journeys timebands time_tables stop_points routing_constraint_zones routes route_sections pt_links networks lines
    journey_patterns group_of_lines connection_links companies access_points access_links)

    models.each do |table|
      if !column_exists?(table, :created_at) && column_exists?(table, :creation_time)
        add_timestamps table
        Object.const_get("Chouette::#{table.to_s.classify}").record_class.update_all 'created_at = creation_time'
      end
      remove_column table, :creation_time if column_exists?(table, :creation_time)
    end
  end
end
