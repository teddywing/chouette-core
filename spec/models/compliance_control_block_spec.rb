require 'rails_helper'

RSpec.describe ComplianceControlBlock, type: :model do
  subject { create(:compliance_control_block) }

  it 'should have a valid factory' do
    expect(FactoryGirl.build(:compliance_control_block)).to be_valid
  end

  it { should belong_to :compliance_control_set }
  it { should have_many(:compliance_controls).dependent(:destroy) }
end
