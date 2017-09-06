require 'rails_helper'

RSpec.describe ComplianceCheckResult, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:compliance_check_result)).to be_valid
  end

  it { should belong_to :compliance_check }
  it { should belong_to :compliance_check_resource }
end
