
RSpec.describe RouteControl::StopPointInJourneyPattern, type: :model do
  let( :default_code ){ "3-Generic-2" }
  let( :factory ){ :route_control_stop_point_in_journey_pattern }

  it_behaves_like 'ComplianceControl Class Level Defaults' 
end
