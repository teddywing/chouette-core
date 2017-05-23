require 'spec_helper'

describe Chouette::VehicleJourneyAtStopsAreInIncreasingTimeOrderValidator do
  subject { create(:vehicle_journey_odd) }

  describe "#increasing_times" do
    before(:each) do
      subject.vehicle_journey_at_stops[0].departure_time =
        subject.vehicle_journey_at_stops[1].departure_time - 5.hour
      subject.vehicle_journey_at_stops[0].arrival_time =
        subject.vehicle_journey_at_stops[0].departure_time
      subject.vehicle_journey_at_stops[1].arrival_time =
        subject.vehicle_journey_at_stops[1].departure_time
    end

    it "should make instance invalid" do
      subject.validate

      expect(
        subject.vehicle_journey_at_stops[1].errors[:departure_time]
      ).not_to be_blank
      expect(subject).not_to be_valid
    end
  end
end
