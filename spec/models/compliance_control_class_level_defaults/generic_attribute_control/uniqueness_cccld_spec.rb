RSpec.describe GenericAttributeControl::Uniqueness, type: :model do
  let( :default_code ){ "3-Generic-3" }
  let( :factory ){ :uniqueness }

  it_behaves_like 'ComplianceControl Class Level Defaults' 
end
