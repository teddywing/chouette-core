object @vehicle_journey

[:objectid, :published_journey_name, :published_journey_identifier, :company_id].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end

node { |vj| {short_id: vj.get_objectid.short_id} }

child(:company) do |company|
  attributes :id, :objectid, :name
end

child(:route) do |route|
  child(:line) do |line|
    attributes :transport_mode, :transport_submode
  end
end

child(:journey_pattern) do |journey_pattern|
  attributes :id, :objectid, :name, :published_name
  node(:short_id) {journey_pattern.get_objectid.short_id}
end

child(:time_tables, :object_root => false) do |time_tables|
  attributes :id, :objectid, :comment, :color
  child(:calendar) do
    attributes :id, :name, :date_ranges, :dates, :shared
  end
end

if has_feature? :purchase_windows
  child(:purchase_windows, :object_root => false) do |purchase_windows|
    attributes :id, :objectid, :name, :color
  end
end

child :footnotes, :object_root => false do |footnotes|
  attributes :id, :code, :label
end

child(:vehicle_journey_at_stops_matrix, :object_root => false) do |vehicle_stops|
  node do |vehicle_stop|
    [:id, :connecting_service_id, :boarding_alighting_possibility].map do |att|
      node(att) { vehicle_stop.send(att) ? vehicle_stop.send(att) : nil  }
    end

    node(:dummy) { vehicle_stop.dummy }

    node(:stop_area_object_id) do
      vehicle_stop.stop_point.stop_area.objectid
    end
    node(:stop_point_objectid) do
      vehicle_stop.stop_point.objectid
    end
    node(:stop_area_name) do
      vehicle_stop.stop_point.stop_area.name
    end
    node(:stop_area_cityname) do
      vehicle_stop.stop_point.stop_area.city_name
    end

    [:arrival_time, :departure_time].each do |att|
      node(att) do |vs|
        {
          hour: vs.send(att).try(:strftime, '%H'),
          minute: vs.send(att).try(:strftime, '%M')
        }
      end
    end
  end
end
