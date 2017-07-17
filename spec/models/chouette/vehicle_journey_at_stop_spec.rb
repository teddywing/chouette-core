require 'spec_helper'

RSpec.describe Chouette::VehicleJourneyAtStop, type: :model do
  it do
    should validate_numericality_of(:arrival_day_offset)
      .is_greater_than_or_equal_to(0)
      .is_less_than_or_equal_to(Chouette::VehicleJourneyAtStop::DAY_OFFSET_MAX)
  end

  it do
    should validate_numericality_of(:departure_day_offset)
      .is_greater_than_or_equal_to(0)
      .is_less_than_or_equal_to(Chouette::VehicleJourneyAtStop::DAY_OFFSET_MAX)
  end

  describe "#validate" do
    it "displays the proper error message when day offset exceeds the max" do
      bad_offset = Chouette::VehicleJourneyAtStop::DAY_OFFSET_MAX + 1

      at_stop = build_stubbed(
        :vehicle_journey_at_stop,
        arrival_day_offset: bad_offset,
        departure_day_offset: bad_offset
      )

      at_stop.validate

      expect(at_stop.errors[:arrival_day_offset]).to include(
        I18n.t('vehicle_journey_at_stops.errors.day_offset_must_not_exceed_max')
      )
      expect(at_stop.errors[:departure_day_offset]).to include(
        I18n.t('vehicle_journey_at_stops.errors.day_offset_must_not_exceed_max')
      )
    end
  end
end
