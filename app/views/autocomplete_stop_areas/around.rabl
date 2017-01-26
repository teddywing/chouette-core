object false
node(:type) { "FeatureCollection" }

child @stop_areas, root: :features, object_root: false do
  node(:type) { "Feature" }
  attributes :id
  node :geometry do |s|
    { coordinates: [s.longitude, s.latitude], type: "Point" }
  end

  node :properties do |s|
    { name: s.name }
  end
end
