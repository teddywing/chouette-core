RSpec.describe StopAreasToWayCostsConverter do
  describe "#convert" do
    it "converts a StopArea collection to WayCosts" do
      route = create(:route_common)
      coordinates = [
        [1.5, 1.8],
        [2.2, 2.1],
        [3.0, 3.6],
        [4.9, 4.3]
      ]

      stop_areas = coordinates.map do |latlng|
        stop_area = create(
          :stop_area,
          area_type: 'zdep',
          latitude: latlng[0],
          longitude: latlng[1]
        )

        create(
          :stop_point,
          route: route,
          stop_area: stop_area
        )

        stop_area
      end

      way_costs = [
        WayCost.new(
          departure: Geokit::LatLng.new(
            stop_areas[0].latitude,
            stop_areas[0].longitude
          ),
          arrival: Geokit::LatLng.new(
            stop_areas[1].latitude,
            stop_areas[1].longitude
          ),
          id: "#{stop_areas[0].id}-#{stop_areas[1].id}"
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(
            stop_areas[1].latitude,
            stop_areas[1].longitude
          ),
          arrival: Geokit::LatLng.new(
            stop_areas[2].latitude,
            stop_areas[2].longitude
          ),
          id: "#{stop_areas[1].id}-#{stop_areas[2].id}"
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(
            stop_areas[2].latitude,
            stop_areas[2].longitude
          ),
          arrival: Geokit::LatLng.new(
            stop_areas[3].latitude,
            stop_areas[3].longitude
          ),
          id: "#{stop_areas[2].id}-#{stop_areas[3].id}"
        )
      ]

      expect(
        StopAreasToWayCostsConverter.new(stop_areas).convert
      ).to eq(way_costs)
    end
  end
end
