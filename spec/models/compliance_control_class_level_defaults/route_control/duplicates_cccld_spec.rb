
RSpec.describe RouteControl::Duplicates, type: :model do
  let( :default_code ){ "3-Generic-2" }
  let( :factory ){ :route_control_duplicates }

  it_behaves_like 'ComplianceControl Class Level Defaults' 
end
