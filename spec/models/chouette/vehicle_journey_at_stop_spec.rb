require 'rails_helper'

RSpec.describe Chouette::VehicleJourneyAtStop, type: :model do
  let(:subject) { create(:vehicle_journey_at_stop) }

  describe 'checksum' do
    it_behaves_like 'checksum support', :vehicle_journey_at_stop

    context '#checksum_attributes' do
      it 'should return attributes' do
        expected = [subject.departure_time.to_s(:time), subject.arrival_time.to_s(:time)]
        expected << subject.departure_day_offset.to_s
        expected << subject.arrival_day_offset.to_s
        expect(subject.checksum_attributes).to include(*expected)
      end
    end
  end
end
