RSpec.describe ComplianceCheck, type: :model do

  it 'should have a valid factory' do
    expect(FactoryGirl.build(:compliance_check)).to be_valid
  end

  it 'has STI disabled' do
    expect( described_class.inheritance_column ).to be_blank
  end

  it { should belong_to :compliance_check_set }
  it { should belong_to :compliance_check_block }

  it { should validate_presence_of :criticity }
  it { should validate_presence_of :name }
  it { should validate_presence_of :code }
  it { should validate_presence_of :origin_code }
end
