RSpec.describe RouteWayCostJSONSerializer do
  describe ".dump" do
    it "converts distance from meters to km and time from seconds to minutes" do
      costs = {
        '1-2': {
          'distance' => 35223,
          'time' => 5604
        },
        '94435-97513' => {
          'distance' => 35919,
          'time' => 6174
        }
      }

      expect(
        RouteWayCostJSONSerializer.dump(costs)
      ).to eq(<<-JSON.delete(" \n"))
        {
          "1-2": {
            "distance": 35.223,
            "time": 93
          },
          "94435-97513": {
            "distance": 35.919,
            "time": 102
          }
        }
      JSON
    end
  end
end
