class ComplianceControl < ActiveRecord::Base
  extend Enumerize
  belongs_to :compliance_control_set
  belongs_to :compliance_control_block

  enumerize :criticity, in: %i(warning error), scope: true, default: :warning
  hstore_accessor :control_attributes, {}

  validates :criticity, presence: true
  validates :name, presence: true
  validates :code, presence: true
  validates :origin_code, presence: true
  validates :compliance_control_set, presence: true

  class << self
    def create *args
      super.tap do | x |
        require 'pry'; binding.pry
      end
    end
    def default_criticity; :warning end
    def default_code; "" end
    def dynamic_attributes
      hstore_metadata_for_control_attributes.keys
    end

    def policy_class
      ComplianceControlPolicy
    end

    def inherited(child)
      child.instance_eval do
        def model_name
          ComplianceControl.model_name
        end
      end
      super
    end
  end

  before_validation(on: :create) do
   self.name ||= self.class.name
   self.code ||= self.class.default_code
   self.origin_code ||= self.class.default_code
  end

end

# Ensure STI subclasses are loaded
# http://guides.rubyonrails.org/autoloading_and_reloading_constants.html#autoloading-and-sti
require_dependency 'generic_attribute_control/min_max'
require_dependency 'generic_attribute_control/pattern'
require_dependency 'generic_attribute_control/uniqueness'
require_dependency 'journey_pattern_control/duplicates'
require_dependency 'journey_pattern_control/vehicle_journey'
require_dependency 'line_control/route'
require_dependency 'route_control/duplicates'
require_dependency 'route_control/journey_pattern'
require_dependency 'route_control/minimum_length'
require_dependency 'route_control/omnibus_journey_pattern'
require_dependency 'route_control/opposite_route_terminus'
require_dependency 'route_control/opposite_route'
require_dependency 'route_control/stop_points_in_journey_pattern'
require_dependency 'route_control/time_table'
require_dependency 'route_control/unactivated_stop_points'
require_dependency 'route_control/vehicle_journey_at_stops'
require_dependency 'route_control/zdl_stop_area'
require_dependency 'routing_constraint_zone_control/maximum_length'
require_dependency 'routing_constraint_zone_control/minimum_length'
require_dependency 'routing_constraint_zone_control/unactivated_stop_point'
require_dependency 'vehicle_journey_control/delta'
require_dependency 'vehicle_journey_control/waiting_time'
require_dependency 'vehicle_journey_control/speed'
