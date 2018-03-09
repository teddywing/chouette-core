RSpec.describe TomTom do
  let(:tomtom) { TomTom.new }

  describe "#convert_way_costs_for_batch" do
    it "turns WayCost points into a collection of colon-separated strings" do
      way_costs = [
        WayCost.new(
          departure: Geokit::LatLng.new(2, 48),
          arrival: Geokit::LatLng.new(3, 46)
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(-71, 42),
          arrival: Geokit::LatLng.new(-71.5, 42.9)
        )
      ]

      expect(
        tomtom.convert_way_costs_for_batch(way_costs)
      ).to eq([
        '2,48:3,46',
        '-71,42:-71.5,42.9'
      ])
    end
  end
end
