require 'rails_helper'

RSpec.describe ComplianceCheckBlock, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:compliance_check_block)).to be_valid
  end

  it { should belong_to :compliance_check_set }
end
