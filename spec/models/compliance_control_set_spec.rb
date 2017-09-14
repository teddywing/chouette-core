require 'rails_helper'

RSpec.describe ComplianceControlSet, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:compliance_control_set)).to be_valid
  end

  it { should belong_to :organisation }
end
