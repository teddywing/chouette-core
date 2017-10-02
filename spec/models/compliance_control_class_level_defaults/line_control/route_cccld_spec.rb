
RSpec.describe LineControl::Route, type: :model do
  let( :default_code ){ "3-Generic-2" }
  let( :factory ){ :line_control_route }

  it_behaves_like 'ComplianceControl Class Level Defaults' 
end
