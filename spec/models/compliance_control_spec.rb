RSpec.describe ComplianceControl, type: :model do

  let(:compliance_control) { create :compliance_control }

  it 'should have a valid factory' do
    expect(compliance_control).to be_valid
  end

  it { should belong_to :compliance_control_set }
  it { should belong_to :compliance_control_block }


  it { should validate_presence_of :criticity }
  it 'should validate_presence_of :name' do
    expect( build :compliance_control, name: '' ).to_not be_valid 
  end
  it { should validate_presence_of :code }
  it { should validate_presence_of :origin_code }

end
