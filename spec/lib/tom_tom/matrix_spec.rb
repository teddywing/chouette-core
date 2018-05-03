RSpec.describe TomTom::Matrix do
  let(:matrix) { TomTom::Matrix.new(nil) }

  describe "#points_from_way_costs" do
    it "extracts a set of lat/lng coordinates from a list of WayCosts" do
      way_costs = [
        WayCost.new(
          departure: Geokit::LatLng.new(48.85086, 2.36143),
          arrival: Geokit::LatLng.new(47.91231, 1.87606),
          id: '44-77'
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(47.91231, 1.87606),
          arrival: Geokit::LatLng.new(52.50867, 13.42879),
          id: '77-88'
        )
      ]

      expect(
        matrix.points_from_way_costs(way_costs)
      ).to eq([
        TomTom::Matrix::Point.new(
          Geokit::LatLng.new(48.85086, 2.36143),
          '44'
        ),
        TomTom::Matrix::Point.new(
          Geokit::LatLng.new(47.91231, 1.87606),
          '77'
        ),
        TomTom::Matrix::Point.new(
          Geokit::LatLng.new(52.50867, 13.42879),
          '88'
        )
      ])
    end
  end

  describe "#points_as_params" do
    it "transforms a set of LatLng points into a hash for use by TomTom Matrix" do
      points = [
        TomTom::Matrix::Point.new(
          Geokit::LatLng.new(48.85086, 2.36143),
          '44'
        ),
        TomTom::Matrix::Point.new(
          Geokit::LatLng.new(47.91231, 1.87606),
          '77'
        ),
        TomTom::Matrix::Point.new(
          Geokit::LatLng.new(52.50867, 13.42879),
          '88'
        )
      ]

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

  describe "#build_request_body" do
    it "serializes BigDecimal coordinates to floats" do
      points = [
        {
          point: {
            latitude: 48.85086.to_d,
            longitude: 2.36143.to_d
          },
        },
        {
          point: {
            latitude: 47.91231.to_d,
            longitude: 1.87606.to_d
          },
        },
        {
          point: {
            latitude: 52.50867.to_d,
            longitude: 13.42879.to_d
          },
        }
      ]

      expect(
        matrix.build_request_body(points)
      ).to eq(<<-JSON.delete(" \n"))
        {
          "origins": [
            {
              "point": {
                "latitude": 48.85086,
                "longitude": 2.36143
              }
            },
            {
              "point": {
                "latitude": 47.91231,
                "longitude": 1.87606
              }
            },
            {
              "point": {
                "latitude": 52.50867,
                "longitude": 13.42879
              }
            }
          ],
          "destinations": [
            {
              "point": {
                "latitude": 48.85086,
                "longitude": 2.36143
              }
            },
            {
              "point": {
                "latitude": 47.91231,
                "longitude": 1.87606
              }
            },
            {
              "point": {
                "latitude": 52.50867,
                "longitude": 13.42879
              }
            }
          ]
        }
      JSON
    end
  end

  describe "#check_for_error_response" do
    it "raises a RemoteError when an 'error' key is present in the response" do
      response = double(
        'response',
        status: 200,
        body: JSON.dump({
          'formatVersion' => '0.0.1',
          'error' => {
            'description' => 'Output format: csv is unsupported.'
          }
        })
      )

      expect {
        matrix.check_for_error_response(response)
      }.to raise_error(
        TomTom::Matrix::RemoteError,
        "status: #{response.status}, message: Output format: csv is unsupported."
      )
    end

    it "raises a RemoteError when response status is not 200" do
      response = double(
        'response',
        status: 403,
        body: '<h1>Developer Inactive</h1>'
      )

      expect {
        matrix.check_for_error_response(response)
      }.to raise_error(
        TomTom::Matrix::RemoteError,
        "status: #{response.status}, body: <h1>Developer Inactive</h1>"
      )
    end

    it "doesn't raise an error when response status is 200" do
      response = double(
        'response',
        status: 200,
        body: JSON.dump({
          'formatVersion' => '0.0.1',
          'matrix' => []
        })
      )

      expect {
        matrix.check_for_error_response(response)
      }.not_to raise_error
    end

    it "doesn't raise errors with a normal response" do
      response = double(
        'response',
        status: 200,
        body: JSON.dump({
          'formatVersion' => '0.0.1',
          'matrix' => []
        })
      )

      expect {
        matrix.check_for_error_response(response)
      }.to_not raise_error
    end
  end

  describe "#extract_costs_to_way_costs!" do
    it "puts distance & time costs in way_costs" do
      way_costs = [
        WayCost.new(
          departure: Geokit::LatLng.new(48.85086, 2.36143),
          arrival: Geokit::LatLng.new(47.91231, 1.87606),
          id: '55-99'
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(47.91231, 1.87606),
          arrival: Geokit::LatLng.new(52.50867, 13.42879),
          id: '99-22'
        )
      ]

      expected_way_costs = [
        WayCost.new(
          departure: Geokit::LatLng.new(48.85086, 2.36143),
          arrival: Geokit::LatLng.new(47.91231, 1.87606),
          distance: 117947,
          time: 8356,
          id: '55-99'
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(48.85086, 2.36143),
          arrival: Geokit::LatLng.new(52.50867, 13.42879),
          distance: 999088,
          time: 62653,
          id: '55-22'
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(47.91231, 1.87606),
          arrival: Geokit::LatLng.new(48.85086, 2.36143),
          distance: 117231,
          time: 9729,
          id: '99-55'
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(47.91231, 1.87606),
          arrival: Geokit::LatLng.new(52.50867, 13.42879),
          distance: 1114635,
          time: 72079,
          id: '99-22'
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(52.50867, 13.42879),
          arrival: Geokit::LatLng.new(48.85086, 2.36143),
          distance: 997232,
          time: 63245,
          id: '22-55'
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(52.50867, 13.42879),
          arrival: Geokit::LatLng.new(47.91231, 1.87606),
          distance: 1113108,
          time: 68485,
          id: '22-99'
        ),
        WayCost.new(
          departure: Geokit::LatLng.new(52.50867, 13.42879),
          arrival: Geokit::LatLng.new(52.50867, 13.42879),
          distance: 344,
          time: 109,
          id: '22-22'
        )
      ]

      matrix_response = JSON.parse(read_fixture('tom_tom_matrix.json'))

      points = matrix.points_from_way_costs(way_costs)

      expect(
        matrix.extract_costs_to_way_costs!(way_costs, points, matrix_response)
      ).to match_array(expected_way_costs)
    end
  end
end
