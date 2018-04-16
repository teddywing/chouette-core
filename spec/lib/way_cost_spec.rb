RSpec.describe WayCost do
  describe "#cache_key" do
    it "returns a cache string including the ID of the WayCost" do
      way_cost = WayCost.new(
        departure: Geokit::LatLng.new(47.91231, 1.87606),
        arrival: Geokit::LatLng.new(52.50867, 13.42879),
        id: '2-3'
      )

      expect(way_cost.cache_key).to eq('way_cost/2-3')
    end

    it "raises an error if the WayCost doesn't have an ID" do
      way_cost = WayCost.new(
        departure: Geokit::LatLng.new(47.91231, 1.87606),
        arrival: Geokit::LatLng.new(52.50867, 13.42879)
      )

      expect { way_cost.cache_key }.to raise_error(WayCost::NullIDError)
    end
  end
end
