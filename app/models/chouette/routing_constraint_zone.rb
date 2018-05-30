module Chouette
  class RoutingConstraintZone < Chouette::TridentActiveRecord
    has_metadata
    include ChecksumSupport
    include ObjectidSupport

    belongs_to :route
    has_array_of :stop_points, class_name: 'Chouette::StopPoint'

    attr_accessor :allow_entire_journey

    belongs_to_array_in_many :vehicle_journeys, class_name: 'Chouette::VehicleJourney', array_name: :ignored_routing_contraint_zones

    def update_vehicle_journey_checksums
      vehicle_journeys.each(&:update_checksum!)
    end
    after_save :update_vehicle_journey_checksums

    validates_presence_of :name, :stop_points, :route_id
    # validates :stop_point_ids, length: { minimum: 2, too_short: I18n.t('activerecord.errors.models.routing_constraint_zone.attributes.stop_points.not_enough_stop_points') }
    validate :stop_points_belong_to_route
    validate :not_all_stop_points_selected, unless: :allow_entire_journey

    def local_id
      "IBOO-#{self.referential.id}-#{self.route.line.get_objectid.local_id}-#{self.route.id}-#{self.id}"
    end

    scope :order_by_stop_points_count, ->(direction) do
      order("array_length(stop_point_ids, 1) #{direction}")
    end

    scope :order_by_route_name, ->(direction) do
      joins(:route)
        .order("routes.name #{direction}")
    end

    def checksum_attributes
      [
        self.stop_points.map(&:stop_area).map(&:user_objectid)
      ]
    end

    def update_route_checksum
      route.update_checksum!
    end
    after_commit :update_route_checksum

    def stop_points_belong_to_route
      return unless route

      errors.add(:stop_point_ids, I18n.t('activerecord.errors.models.routing_constraint_zone.attributes.stop_points.stop_points_not_from_route')) unless stop_points.all? { |sp| route.stop_points.include? sp }
    end

    def not_all_stop_points_selected
      return unless route

      errors.add(:stop_point_ids, I18n.t('activerecord.errors.models.routing_constraint_zone.attributes.stop_points.all_stop_points_selected')) if stop_points.length == route.stop_points.length
    end

    def stop_points_count
      stop_points.count
    end

    def route_name
      route.name
    end

    def pretty_print
      stop_points.map(&:registration_number).join(' > ')
    end
  end
end
