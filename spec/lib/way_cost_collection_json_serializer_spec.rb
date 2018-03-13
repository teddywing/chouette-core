RSpec.describe WayCostCollectionJSONSerializer do
  describe ".dump" do
    it "creates a JSON hash of hashed WayCost attributes" do
      way_costs = [
        WayCost.new(
          departure: Geokit::LatLng.new(48.85086, 2.36143),
          arrival: Geokit::LatLng.new(47.91231, 1.87606),
          distance: 1234,
          time: 99,
          id: '1-2'
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(47.91231, 1.87606),
          arrival: Geokit::LatLng.new(52.50867, 13.42879),
          distance: 5678,
          time: 999,
          id: '2-3'
        )
      ]

      expect(
        WayCostCollectionJSONSerializer.dump(way_costs)
      ).to eq(<<-JSON.delete(" \n"))
        {
          "1-2": {
            "distance": 1234,
            "time": 99
          },
          "2-3": {
            "distance": 5678,
            "time": 999
          }
        }
      JSON
    end
  end
end
