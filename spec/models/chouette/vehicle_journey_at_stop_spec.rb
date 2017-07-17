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
end
