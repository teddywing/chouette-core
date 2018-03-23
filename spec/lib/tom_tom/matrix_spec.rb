RSpec.describe TomTom::Matrix do
  let(:matrix) { TomTom::Matrix.new(nil) }

  describe "#points_from_way_costs" do
    it "extracts a set of lat/lng coordinates from a list of WayCosts" do
      way_costs = [
        WayCost.new(
          departure: Geokit::LatLng.new(48.85086, 2.36143),
          arrival: Geokit::LatLng.new(47.91231, 1.87606)
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(47.91231, 1.87606),
          arrival: Geokit::LatLng.new(52.50867, 13.42879)
        )
      ]

      expect(
        matrix.points_from_way_costs(way_costs)
      ).to eq(Set.new([
        Geokit::LatLng.new(48.85086, 2.36143),
        Geokit::LatLng.new(47.91231, 1.87606),
        Geokit::LatLng.new(52.50867, 13.42879)
      ]))
    end
  end

  describe "#points_as_params" do
    it "transforms a set of LatLng points into a hash for use by TomTom Matrix" do
      points = Set.new([
        Geokit::LatLng.new(48.85086, 2.36143),
        Geokit::LatLng.new(47.91231, 1.87606),
        Geokit::LatLng.new(52.50867, 13.42879)
      ])

      expect(
        matrix.points_as_params(points)
      ).to eq([
        {
          point: {
            latitude: 48.85086,
            longitude: 2.36143
          },
        },
        {
          point: {
            latitude: 47.91231,
            longitude: 1.87606
          },
        },
        {
          point: {
            latitude: 52.50867,
            longitude: 13.42879
          },
        }
      ])
    end
  end

  describe "#extract_costs_to_way_costs!" do
    it "puts distance & time costs in way_costs" do
      way_costs = [
        WayCost.new(
          departure: Geokit::LatLng.new(48.85086, 2.36143),
          arrival: Geokit::LatLng.new(47.91231, 1.87606)
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(47.91231, 1.87606),
          arrival: Geokit::LatLng.new(52.50867, 13.42879)
        )
      ]

      expected_way_costs = [
        WayCost.new(
          departure: Geokit::LatLng.new(48.85086, 2.36143),
          arrival: Geokit::LatLng.new(47.91231, 1.87606),
          distance: 117947,
          time: 8356
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(48.85086, 2.36143),
          arrival: Geokit::LatLng.new(52.50867, 13.42879),
          distance: 999088,
          time: 62653
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(47.91231, 1.87606),
          arrival: Geokit::LatLng.new(48.85086, 2.36143),
          distance: 117231,
          time: 9729
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(47.91231, 1.87606),
          arrival: Geokit::LatLng.new(52.50867, 13.42879),
          distance: 1114635,
          time: 72079
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(52.50867, 13.42879),
          arrival: Geokit::LatLng.new(48.85086, 2.36143),
          distance: 997232,
          time: 63245
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(52.50867, 13.42879),
          arrival: Geokit::LatLng.new(47.91231, 1.87606),
          distance: 1113108,
          time: 68485
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(52.50867, 13.42879),
          arrival: Geokit::LatLng.new(52.50867, 13.42879),
          distance: 344,
          time: 109
        )
      ]

      matrix_response = JSON.parse(read_fixture('tom_tom_matrix.json'))

      points = matrix.points_as_params(matrix.points_from_way_costs(way_costs))

      expect(
        matrix.extract_costs_to_way_costs!(way_costs, points, matrix_response)
      ).to match_array(expected_way_costs)
    end
  end
end
