class SetUserPermissions < ActiveRecord::Migration
  def change
    User.update_all(permissions: ['routes.create', 'routes.edit', 'routes.destroy', 'journey_patterns.create', 'journey_patterns.edit', 'journey_patterns.destroy',
      'vehicle_journeys.create', 'vehicle_journeys.edit', 'vehicle_journeys.destroy', 'time_tables.create', 'time_tables.edit', 'time_tables.destroy',
      'footnotes.edit', 'footnotes.create', 'footnotes.destroy', 'routing_constraint_zones.create', 'routing_constraint_zones.edit', 'routing_constraint_zones.destroy'])
  end
end
