
RSpec.describe GenericAttributeControl::Pattern, type: :model do
  let( :default_code ){ "3-Generic-3" }
  let( :factory ){ :pattern }

  it_behaves_like 'ComplianceControl Class Level Defaults' 
end
