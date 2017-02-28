object @vehicle_journey

[ :objectid, :published_journey_name, :published_journey_identifier, :company_id].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr)}
end

child(:journey_pattern) do |journey_pattern|
  attributes :id, :objectid, :name, :published_name
end

child(:time_tables, :object_root => false) do |time_tables|
  attributes :objectid, :comment
  child(:calendar) do
    attributes :id, :name, :date_ranges, :dates, :shared
  end
end

child :footnotes, :object_root => false do |footnotes|
  attributes :id, :code, :label
end

child :vehicle_journey_at_stops, :object_root => false do |vehicle_stops|
  node do |vehicle_stop|
    node(:stop_area_object_id) { vehicle_stop.stop_point.stop_area.objectid }
    node(:stop_area_name) {vehicle_stop.stop_point.stop_area.name}
    [:id, :connecting_service_id, :boarding_alighting_possibility].map do |att|
      node(att) { vehicle_stop.send(att) } unless vehicle_stop.send(att).nil?
    end

    [:arrival_time, :departure_time].map do |att|
      node(att) do |vs|
        {
          hour: vs.send(att).try(:strftime, '%H'),
          minute: vs.send(att).try(:strftime, '%M')
        }
      end
    end
  end
end
