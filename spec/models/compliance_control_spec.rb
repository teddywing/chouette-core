require 'rails_helper'

RSpec.describe ComplianceControl, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:compliance_control)).to be_valid
  end

  it { should belong_to :compliance_control_set }
  it { should belong_to :compliance_control_block }

  it { should validate_presence_of :criticity }
  it { should validate_presence_of :name }
  it { should validate_presence_of :code }
end
