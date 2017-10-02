
RSpec.describe RouteControl::UnactivatedStopPoint, type: :model do
  let( :default_code ){ "3-Generic-2" }
  let( :factory ){ :route_control_unactivated_stop_point }

  it_behaves_like 'ComplianceControl Class Level Defaults' 
end
