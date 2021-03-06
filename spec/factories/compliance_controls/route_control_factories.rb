FactoryGirl.define do

  factory :route_control_duplicates, class: 'RouteControl::Duplicates' do
    association :compliance_control_set
  end

  factory :route_control_journey_pattern, class: 'RouteControl::JourneyPattern' do
    association :compliance_control_set
  end

  factory :route_control_minimum_length, class: 'RouteControl::MinimumLength' do
    association :compliance_control_set
  end

  factory :route_control_omnibus_journey_pattern, class: 'RouteControl::OmnibusJourneyPattern' do
    association :compliance_control_set
  end

  factory :route_control_opposite_route, class: 'RouteControl::OppositeRoute' do
    association :compliance_control_set
  end

  factory :route_control_opposite_route_terminus, class: 'RouteControl::OppositeRouteTerminus' do
    association :compliance_control_set
  end

  factory :route_control_stop_points_in_journey_pattern, class: 'RouteControl::StopPointsInJourneyPattern' do
    association :compliance_control_set
  end

  factory :route_control_unactivated_stop_point, class: 'RouteControl::UnactivatedStopPoint' do
    association :compliance_control_set
  end

  factory :route_control_zdl_stop_area, class: 'RouteControl::ZDLStopArea' do
    association :compliance_control_set
  end
end
