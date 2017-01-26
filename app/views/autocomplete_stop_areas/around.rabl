object false
node(:type) { "FeatureCollection" }

child @stop_areas, root: :features, object_root: false do
  node(:type) { "Feature" }
  node :geometry do |s|
    { coordinates: [s.longitude, s.latitude], type: "Point" }
  end

  node :properties do |s|
    {
      name: s.name,
      registration_number: s.registration_number,
      stoparea_id: s.id,
      text: "#{s.name} #{s.zip_code} #{s.city_name}",
      user_objectid: s.user_objectid
    }
  end
end
