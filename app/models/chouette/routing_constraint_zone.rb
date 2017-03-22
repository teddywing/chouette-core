class Chouette::RoutingConstraintZone < Chouette::TridentActiveRecord
  belongs_to :line
  has_array_of :stop_areas, class_name: 'Chouette::StopArea'

  validates_presence_of :name, :stop_area_ids, :line_id
  validates :stop_areas, length: { minimum: 2 }

  self.primary_key = 'id'
end
