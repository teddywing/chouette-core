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
        },
        '2-3' => {
          'distance' => nil,
          'time' => nil
        }
      }

      expect(
        RouteWayCostUnitConverter.convert(costs)
      ).to eq({
        '1-2' => {
          'distance' => 35,
          'time' => 93
        },
        '94435-97513' => {
          'distance' => 35,
          'time' => 102
        },
        '2-3' => {
          'distance' => 0,
          'time' => 0
        }
      })
    end
  end

  describe ".meters_to_kilometers" do
    it "converts meters to integer kilometres" do
      expect(
        RouteWayCostUnitConverter.meters_to_kilometers(6350)
      ).to eq(6)
    end

    it "snaps values between 0 and 1 to 1" do
      expect(
        RouteWayCostUnitConverter.meters_to_kilometers(50)
      ).to eq(1)
    end
  end

  describe ".seconds_to_minutes" do
    it "converts seconds to minutes" do
      expect(
        RouteWayCostUnitConverter.seconds_to_minutes(300)
      ).to eq(5)
    end

    it "snaps values between 0 and 1 to 1" do
      expect(
        RouteWayCostUnitConverter.seconds_to_minutes(3)
      ).to eq(1)
    end
  end
end
