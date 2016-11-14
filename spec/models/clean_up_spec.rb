require 'rails_helper'

RSpec.describe CleanUp, :type => :model do
  let(:cleaner) { CleanUp.new }

  it { should validate_presence_of(:expected_date) }
  it { should belong_to(:referential) }

  it 'should convert initialize attribute to boolean' do
    params  = { keep_lines: "0", keep_stops: "1" }
    cleaner = CleanUp.new(params)
    expect(cleaner.keep_lines).to eq false
    expect(cleaner.keep_stops).to eq true
  end

  it 'should delete group of line without lines' do
    create_list(:group_of_line, 2)
    create_list(:line, 2, group_of_lines: [create(:group_of_line)])
    expect(cleaner.clean_group_of_lines).to eq 2
  end

  it 'should delete company without lines' do
    create_list(:company, 2)
    create_list(:line, 2)
    expect(cleaner.clean_companies).to eq 2
  end

  it 'should delete physical stop_areas without stop_points' do
    create_list(:stop_area, 2)
    create_list(:stop_point, 2)
    Chouette::StopArea.update_all(area_type: "Quay")
    expect(cleaner.clean_physical_stop_areas).to eq 2
  end

  it 'should delete vehiclejourneys without timetables' do
    create_list(:vehicle_journey, 2)
    create_list(:vehicle_journey, 2, time_tables:[create(:time_table)])
    expect(cleaner.clean_vehicle_journeys).to eq 2
  end

  it 'should delete lines without routes' do
    create_list(:line, 2)
    create_list(:route, 2, line: create(:line))
    expect(cleaner.clean_lines).to eq 2
  end

  it 'should delete routes without journeypatterns' do
    create_list(:route, 2)
    create_list(:journey_pattern, 2, route: create(:route))
    expect(cleaner.clean_routes).to eq 2
  end

  it 'should delete journeypatterns without vehicle journeys' do
    create_list(:journey_pattern, 2)
    create_list(:vehicle_journey, 2, journey_pattern: create(:journey_pattern))
    expect(cleaner.clean_journey_patterns).to eq 2
  end
end
