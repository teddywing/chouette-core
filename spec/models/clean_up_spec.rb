require 'rails_helper'

RSpec.describe CleanUp, :type => :model do
  let(:cleaner) { CleanUp.new }

  it { should validate_presence_of(:begin_date) }
  it { should validate_presence_of(:date_type) }
  it { should belong_to(:referential) }

  it 'should delete vehiclejourneys without timetables' do
    create_list(:vehicle_journey, 2)
    create_list(:vehicle_journey, 2, time_tables:[create(:time_table)])
    expect(cleaner.clean_vehicle_journeys).to eq 2
  end

  it 'should delete journeypatterns without vehicle journeys' do
    create_list(:journey_pattern, 2)
    create_list(:vehicle_journey, 2, journey_pattern: create(:journey_pattern))
    expect(cleaner.clean_journey_patterns).to eq 2
  end
end
