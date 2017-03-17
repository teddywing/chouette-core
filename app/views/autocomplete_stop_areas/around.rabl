object false
node(:type) { "FeatureCollection" }

child @stop_areas, root: :features, object_root: false do
  node(:type) { "Feature" }
  node :geometry do |s|
    { coordinates: [s.longitude.to_f, s.latitude.to_f], type: "Point" }
  end

  node :properties do |s|
    {
      name: s.name,
      area_type: s.area_type,
      registration_number: s.registration_number,
      stoparea_id: s.id,
      text: "#{s.name}, #{s.zip_code} #{s.city_name}",
      user_objectid: s.user_objectid,
      latitude: s.latitude,
      longitude: s.longitude
    }
  end
end
