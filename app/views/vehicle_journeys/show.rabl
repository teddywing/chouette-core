object @vehicle_journey

[ :objectid, :published_journey_name, :journey_pattern_id].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end

child(:time_tables, :object_root => false) do |time_tables|
  node do |tt|
    [:objectid, :comment].map do |att|
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

child :footnotes, :object_root => false do |footnotes|
  node do |footnote|
    {
      id: footnote.id,
      code: footnote.code,
      label: footnote.label
    }
  end
end

child :vehicle_journey_at_stops, :object_root => false do |vehicle_stops|
  node do |vehicle_stop|
    node(:stop_area_object_id) { vehicle_stop.stop_point.stop_area.objectid }
    [:connecting_service_id, :boarding_alighting_possibility].map do |att|
      node(att) { vehicle_stop.send(att) } unless vehicle_stop.send(att).nil?
    end

    [:arrival_time, :departure_time].map do |att|
      node("#{att}_hour".to_sym)   { vehicle_stop.send(att).strftime('%H') }
      node("#{att}_minute".to_sym) { vehicle_stop.send(att).strftime('%M') }
    end
  end
end
