require 'spec_helper'

describe TimeDuration do
  describe ".exceeds_gap?" do
    let!(:vehicle_journey) { create(:vehicle_journey_odd) }
    subject { vehicle_journey.vehicle_journey_at_stops.first }

    context "when duration is 4.hours" do
      it "should return false if gap < 1.hour" do
        t1 = Time.now
        t2 = Time.now + 3.minutes
        expect(TimeDuration.exceeds_gap?(4.hours, t1, t2)).to be_falsey
      end

      it "should return true if gap > 4.hour" do
        t1 = Time.now
        t2 = Time.now + (4.hours + 1.minutes)
        expect(TimeDuration.exceeds_gap?(4.hours, t1, t2)).to be_truthy
      end
    end
  end
end
