FactoryGirl.define do

  factory :vehicle_journey_control_wating_time, class: 'VehicleJourneyControl::WaitingTime' do
    association :compliance_control_set
  end

  factory :vehicle_journey_control_delta, class: 'VehicleJourneyControl::Delta' do
    association :compliance_control_set
  end

  factory :vehicle_journey_control_speed, class: 'VehicleJourneyControl::Speed' do
    association :compliance_control_set
    minimum 200
    maximum 300
  end

  factory :vehicle_journey_control_time_table, class: 'VehicleJourneyControl::TimeTable' do
    association :compliance_control_set
  end

  factory :vehicle_journey_control_vehicle_journey_at_stops, class: 'VehicleJourneyControl::VehicleJourneyAtStops' do
    association :compliance_control_set
  end
end
