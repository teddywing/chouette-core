module Support
  module Permissions extend self

    def all_permissions
      @__all_permissions__ ||= _destructive_permissions << 'sessions.create'
    end

    private

    def _destructive_permissions
      _permitted_resources.product( %w{create destroy update} ).map{ |model_action| model_action.join('.') }
    end

    def _permitted_resources
      %w[
        access_points
        api_keys

        calendars
        companies
        connection_links
        compliance_control_blocks
        compliance_control_sets
        compliance_controls
        compliance_check_sets

        footnotes
        imports
        journey_patterns
        lines
        networks

        referentials
        routes
        routing_constraint_zones

        time_tables
        vehicle_journeys
      ]
    end
  end
end
