
RSpec.describe GenericAttributeControl::Pattern, type: :model do
  let( :default_code ){ "3-Generic-1" }
  let( :factory ){ :generic_attribute_control_pattern }

  it_behaves_like 'ComplianceControl Class Level Defaults'
end
