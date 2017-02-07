class SetReferentialsUserPermissions < ActiveRecord::Migration
  def change
    User.update_all(permissions: ['routes.create', 'routes.edit', 'routes.destroy', 'journey_patterns.create', 'journey_patterns.edit', 'journey_patterns.destroy',
      'vehicle_journeys.create', 'vehicle_journeys.edit', 'vehicle_journeys.destroy', 'time_tables.create', 'time_tables.edit', 'time_tables.destroy',
      'footnotes.edit', 'footnotes.create', 'footnotes.destroy', 'routing_constraint_zones.create', 'routing_constraint_zones.edit', 'routing_constraint_zones.destroy',
      'access_points.create', 'access_points.edit', 'access_points.destroy', 'access_links.create', 'access_links.edit', 'access_links.destroy',
      'connection_links.create', 'connection_links.edit', 'connection_links.destroy', 'route_sections.create', 'route_sections.edit', 'route_sections.destroy'])
  end
end


