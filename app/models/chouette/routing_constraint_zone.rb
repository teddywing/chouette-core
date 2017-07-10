class Chouette::RoutingConstraintZone < Chouette::TridentActiveRecord
  belongs_to :route
  has_array_of :stop_points, class_name: 'Chouette::StopPoint'

  validates_presence_of :name, :stop_points, :route
  validates :stop_point_ids, length: { minimum: 2, too_short: I18n.t('activerecord.errors.models.routing_constraint_zone.attributes.stop_points.not_enough_stop_points') }
  validate :stop_points_belong_to_route, :not_all_stop_points_selected

  def stop_points_belong_to_route
    errors.add(:stop_point_ids, I18n.t('activerecord.errors.models.routing_constraint_zone.attributes.stop_points.stop_points_not_from_route')) unless stop_points.all? { |sp| route.stop_points.include? sp }
  end

  def not_all_stop_points_selected
    errors.add(:stop_point_ids, I18n.t('activerecord.errors.models.routing_constraint_zone.attributes.stop_points.all_stop_points_selected')) if stop_points.length == route.stop_points.length
  end

  def stop_points_count
    stop_points.count
  end

  def route_name
    route.name
  end
end
