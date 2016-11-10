require 'spec_helper'

describe CleanUp, :type => :model do
  let(:cleaner) { CleanUp.new }

  it 'should delete physical stop_areas without stop_points' do
    create_list(:stop_area, 2)
    create_list(:stop_point, 2)
    Chouette::StopArea.update_all(area_type: "Quay")
    expect(cleaner.physical_stop_areas.count).to eq 2
    expect(cleaner.clean_physical_stop_areas).to eq 2
  end

  it 'should delete vehiclejourneys without timetables' do
    create_list(:vehicle_journey, 2)
    create_list(:vehicle_journey, 2, time_tables:[create(:time_table)])
    expect(cleaner.vehicle_journeys.count).to eq 2
    expect(cleaner.clean_vehicle_journeys).to eq 2
  end

  it 'should delete lines without routes' do
    create_list(:line, 2)
    create_list(:route, 2, line: create(:line))
    expect(cleaner.lines.count).to eq 2
    expect(cleaner.clean_lines).to eq 2
  end

  it 'should delete routes without journeypatterns' do
    create_list(:route, 2)
    create_list(:journey_pattern, 2, route: create(:route))
    expect(cleaner.routes.count).to eq 2
    expect(cleaner.clean_routes).to eq 2
  end

  it 'should delete journeypatterns without vehicle journeys' do
    create_list(:journey_pattern, 2)
    create_list(:vehicle_journey, 2, journey_pattern: create(:journey_pattern))
    expect(cleaner.journey_patterns.count).to eq 2
    expect(cleaner.clean_journey_patterns).to eq 2
  end
end
