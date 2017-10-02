
RSpec.describe GenericAttributeControl::MinMax, type: :model do
  let( :default_code ){ "3-Generic-2" }
  let( :factory ){ :min_max }

  it_behaves_like 'ComplianceControl Class Level Defaults' 
end
