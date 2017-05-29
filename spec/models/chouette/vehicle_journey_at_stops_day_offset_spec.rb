require 'spec_helper'

# TODO: Ensure that the fields have a default value of 0

describe Chouette::VehicleJourneyAtStop do
  describe "#calculate" do
    it "increments day offset when departure & arrival are on different sides
        of midnight" do
      at_stops = []
      [
        ['22:30', '22:35'],
        ['23:50', '00:05'],
        ['00:30', '00:35'],
      ].each do |arrival_time, departure_time|
        at_stops << build(
          :vehicle_journey_at_stop,
          arrival_time: "2000-01-01 #{arrival_time} UTC",
          departure_time: "2000-01-01 #{departure_time} UTC",

          # TODO: make this the default
          arrival_day_offset: 0,
          departure_day_offset: 0
        )
      end

      offsetter = Chouette::VehicleJourneyAtStopsDayOffset.new(at_stops)

      offsetter.calculate!

      expect(at_stops[0].arrival_day_offset).to eq(0)
      expect(at_stops[0].departure_day_offset).to eq(0)

      expect(at_stops[1].arrival_day_offset).to eq(0)
      expect(at_stops[1].departure_day_offset).to eq(1)

      expect(at_stops[2].arrival_day_offset).to eq(1)
      expect(at_stops[2].departure_day_offset).to eq(1)
    end

    it "increments day offset when an at_stop passes midnight the next day" do
    end

    it "increments day offset for multi-day offsets" do
    end
  end
end
