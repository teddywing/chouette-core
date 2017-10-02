FactoryGirl.define do

  factory :route_control_journey_pattern, class: 'RouteControl::JourneyPattern' do
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :route_control_minimum_length, class: 'RouteControl::MinimumLength' do
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :route_control_omnibus_journey_pattern, class: 'RouteControl::OmnibusJourneyPattern' do
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :route_control_opposite_route, class: 'RouteControl::OppositeRoute' do
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :route_control_opposite_route_terminus, class: 'RouteControl::OppositeRouteTerminus' do
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :route_control_stop_point_in_journey_pattern, class: 'RouteControl::StopPointInJourneyPattern' do
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :route_control_unactivated_stop_points, class: 'RouteControl::UnactivatedStopPoints' do
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :route_control_zdl_stop_area, class: 'RouteControl::ZdlStopArea' do
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :route_control_control_speed, class: 'RouteControl::ControlSpeed' do
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :route_control_control_time_table, class: 'RouteControl::ControlTimeTable' do
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :route_control_control_vehicle_journey_at_stops, class: 'RouteControl::ControlVehicleJourneyAtStops' do
    association :compliance_control_set
    association :compliance_control_block
  end
end
