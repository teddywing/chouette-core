RSpec.describe RouteWayCostUnitConverter do
  describe ".convert" do
    it "converts distance from meters to km and time from seconds to minutes " \
      "and rounds to two decimal places" do
      costs = {
        '1-2' => {
          'distance' => 35223,
          'time' => 5604
        },
        '94435-97513' => {
          'distance' => 35919,
          'time' => 6174
        }
      }

      expect(
        RouteWayCostUnitConverter.convert(costs)
      ).to eq({
        '1-2' => {
          'distance' => 35.22,
          'time' => 93
        },
        '94435-97513' => {
          'distance' => 35.92,
          'time' => 102
        }
      })
    end
  end
end
