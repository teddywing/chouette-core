RSpec.describe ComplianceCheckBlock, type: :model do

  it { should belong_to :compliance_check_set }
  it { should have_many :compliance_checks }
end
