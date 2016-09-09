require 'rails_helper'

RSpec.describe StopAreaReferentialSync, :type => :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:stop_area_referential_sync)).to be_valid
  end

  it { is_expected.to belong_to(:stop_area_referential) }
  it { is_expected.to have_many(:stop_area_sync_operations) }

  describe '.record_status'
    let!(:stop_area_ref_sync) { create(:stop_area_referential_sync) }
    let!(:stop_area_ref_sync_with_records) { create(:stop_area_referential_sync_with_record, stop_area_sync_operations_count: 30) }

    it 'should add a new record' do
      stop_area_ref_sync.record_status :ok, "message"
      expect(stop_area_ref_sync.stop_area_sync_operations.count).to eq(1)
    end

    it 'should not have more than 30 records' do
      stop_area_ref_sync_with_records.record_status :ok, "message"
      expect(stop_area_ref_sync_with_records.stop_area_sync_operations.count).to eq(30)
    end
end
