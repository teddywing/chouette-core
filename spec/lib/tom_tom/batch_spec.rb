RSpec.describe TomTom::Batch do
  let(:batch) { TomTom::Batch.new(nil) }

  describe "#convert_way_costs" do
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
        batch.convert_way_costs(way_costs)
      ).to eq([
        '2,48:3,46',
        '-71,42:-71.5,42.9'
      ])
    end
  end
end
