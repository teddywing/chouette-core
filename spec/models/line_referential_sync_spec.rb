require 'rails_helper'

RSpec.describe LineReferentialSync, :type => :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:line_referential_sync)).to be_valid
  end

  it { is_expected.to belong_to(:line_referential) }

  it 'should validate multiple sync instance' do
    lref_sync = build(:line_referential_sync, line_referential: create(:line_referential_sync).line_referential)
    expect(lref_sync).to be_invalid
  end

  it 'should call LineReferentialSyncWorker on create' do
    expect(LineReferentialSyncWorker).to receive(:perform_async)
    create :line_referential_sync
  end
end
