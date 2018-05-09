RSpec.describe WayCost do
  describe "#calculate_distance" do
    it "calculates the distance between departure and arrival" do
      way_cost = WayCost.new(
        departure: Geokit::LatLng.new(48.85086, 2.36143),
        arrival: Geokit::LatLng.new(47.91231, 1.87606),
        distance: 1234,
        time: 99,
        id: '1-2'
      )

      departure = RGeoExt.geographic_factory.point(2.36143, 48.85086)
      arrival = RGeoExt.geographic_factory.point(1.87606, 47.91231)

      expect(way_cost.calculate_distance).to eq(departure.distance(arrival))
    end
  end
end
