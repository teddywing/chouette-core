RSpec.describe TomTom::Matrix::RequestJSONSerializer do
  describe ".dump" do
    it "serializes BigDecimal values to floats" do
      points = [{
        point: {
          latitude: 52.50867.to_d,
          longitude: 13.42879.to_d
        },
      }]
      data = {
        origins: points,
        destinations: points
      }

      expect(
        TomTom::Matrix::RequestJSONSerializer.dump(data)
      ).to eq(<<-JSON.delete(" \n"))
        {
          "origins": [
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
                "latitude": 52.50867,
                "longitude": 13.42879
              }
            }
          ]
        }
      JSON
    end
  end
end
