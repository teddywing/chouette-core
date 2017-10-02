
RSpec.describe RouteControl::OppositeRouteTerminus, type: :model do
  let( :default_code ){ "3-Generic-2" }
  let( :factory ){ :route_control_opposite_route_terminus }

  it_behaves_like 'ComplianceControl Class Level Defaults' 
end
