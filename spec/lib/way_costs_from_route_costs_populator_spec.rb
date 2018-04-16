RSpec.describe WayCostsFromRouteCostsPopulator do
  describe "#populate!" do
    it "takes costs from `route_costs` and puts them in the corresponding `way_costs`" do
      way_costs = [
        WayCost.new(
          departure: Geokit::LatLng.new(48.85086, 2.36143),
          arrival: Geokit::LatLng.new(47.91231, 1.87606),
          id: '1-2'
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(47.91231, 1.87606),
          arrival: Geokit::LatLng.new(52.50867, 13.42879),
          id: '2-3'
        )
      ]

      route_costs = {
        '1-2' => {
          'distance' => 1234,
          'time' => 99
        },
        '2-3' => {
          'distance' => 5678,
          'time' => 999
        }
      }

      WayCostsFromRouteCostsPopulator.new(way_costs, route_costs).populate!

      expect(way_costs).to eq([
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
      ])
    end

    it "doesn't fail when `route_costs` doesn't include a WayCost" do
      way_costs = [
        WayCost.new(
          departure: Geokit::LatLng.new(48.85086, 2.36143),
          arrival: Geokit::LatLng.new(47.91231, 1.87606),
          id: '1-2'
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(47.91231, 1.87606),
          arrival: Geokit::LatLng.new(52.50867, 13.42879),
          id: '2-3'
        )
      ]

      route_costs = {
        '1-2' => {
          'distance' => 1234,
          'time' => 99
        }
      }

      WayCostsFromRouteCostsPopulator.new(way_costs, route_costs).populate!

      expect(way_costs).to eq([
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
          id: '2-3'
        )
      ])
    end
  end
end
