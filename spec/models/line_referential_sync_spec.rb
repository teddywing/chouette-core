require 'rails_helper'

RSpec.describe LineReferentialSync, :type => :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:line_referential_sync)).to be_valid
  end

  it { is_expected.to belong_to(:line_referential) }

  describe '.record_status'
    let!(:line_ref_sync) { create(:line_referential_sync) }
    let!(:line_ref_sync_with_records) { create(:line_referential_sync_with_record, line_sync_operations_count: 30) }

    it 'should add a new record' do
      line_ref_sync.record_status :ok, "message"
      expect(line_ref_sync.line_sync_operations.count).to eq(1)
    end

    it 'should not have more than 30 records' do
      line_ref_sync_with_records.record_status :ok, "message"
      expect(line_ref_sync_with_records.line_sync_operations.count).to eq(30)
    end
end
