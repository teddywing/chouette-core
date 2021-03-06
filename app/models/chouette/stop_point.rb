module Chouette
  class StopPoint < Chouette::TridentActiveRecord
    has_metadata
    def self.policy_class
      RoutePolicy
    end

    include ForBoardingEnumerations
    include ForAlightingEnumerations
    include ObjectidSupport

    belongs_to :stop_area
    belongs_to :stop_area_light, -> {select(:name, :city_name, :zip_code, :time_zone, :registration_number, :kind, :area_type, :time_zone)}, class_name: "Chouette::StopArea", foreign_key: :stop_area_id
    belongs_to :route, inverse_of: :stop_points
    has_many :journey_patterns, through: :route
    has_many :vehicle_journey_at_stops, :dependent => :destroy
    has_many :vehicle_journeys, -> {uniq}, :through => :vehicle_journey_at_stops

    acts_as_list :scope => :route, top_of_list: 0

    validates_presence_of :stop_area
    validate :stop_area_id_validation
    def stop_area_id_validation
      if stop_area_id.nil?
        errors.add(:stop_area_id, I18n.t("stop_areas.errors.empty"))
      end
    end

    scope :default_order, -> { order("position") }

    delegate :name, :registration_number, :kind, :area_type, to: :stop_area_light

    before_destroy :remove_dependent_journey_pattern_stop_points
    def remove_dependent_journey_pattern_stop_points
      route.journey_patterns.each do |jp|
        if jp.stop_point_ids.include?( id)
          jp.stop_point_ids = jp.stop_point_ids - [id]
        end
      end
    end

    def duplicate(for_route:, opposite: false)
      keys_for_create = attributes.keys - %w{id objectid created_at updated_at}
      atts_for_create = attributes
        .slice(*keys_for_create)
        .merge('route_id' => for_route.id)
      atts_for_create["position"] = self.route.stop_points.size - atts_for_create["position"] if opposite
      self.class.create!(atts_for_create)
    end

    def local_id
      "IBOO-#{self.referential.id}-#{self.route.line.get_objectid.local_id}-#{self.route.id}-#{self.id}"
    end

    def self.area_candidates
      Chouette::StopArea.where(:area_type => ['Quay', 'BoardingPosition'])
    end
  end
end
