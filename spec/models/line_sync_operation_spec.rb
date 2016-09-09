require 'rails_helper'

RSpec.describe LineSyncOperation, :type => :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:line_sync_operation)).to be_valid
  end

  it { is_expected.to belong_to(:line_referential_sync) }
end
