object @vehicle_journey

[ :objectid, :published_journey_name, :journey_pattern_id].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end

child(:time_tables) do |time_tables|
  node do |tt|
    [:objectid, :start_date, :end_date].map do |att|
      node(att) { tt.send(att) }
    end
    node :calendar do |tt|
      {
        id: tt.calendar.id,
        name: tt.calendar.name,
        date_ranges: tt.calendar.date_ranges,
        dates: tt.calendar.dates,
        shared: tt.calendar.shared
      }
    end
  end
end

child :footnotes do |footnotes|
  node do |footnote|
    node(:id) { footnote.id }
  end
end

child :vehicle_journey_at_stops do |vehicle_stops|
  node do |vehicle_stop|
    node(:stop_area_object_id) { vehicle_stop.stop_point.stop_area.objectid }
    [ :connecting_service_id, :arrival_time, :departure_time, :boarding_alighting_possibility].each do |attr|
      node( attr) do
        vehicle_stop.send(attr)
      end unless vehicle_stop.send(attr).nil?
    end
  end
end
