require 'rails_helper'

RSpec.describe CleanUp, :type => :model do

  it { should validate_presence_of(:begin_date) }
  it { should validate_presence_of(:date_type) }
  it { should belong_to(:referential) }

  context '#clean' do
    let(:cleaner) { create(:clean_up, date_type: :before) }

    it 'should call destroy_time_tables_before' do
      cleaner.date_type = :before
      expect(cleaner).to receive(:destroy_time_tables_before)
      expect(cleaner).to receive(:destroy_time_tables_dates_before)
      expect(cleaner).to receive(:destroy_time_tables_periods_before)
      cleaner.clean
    end

    it 'should call destroy_time_tables_after' do
      cleaner.date_type = :after
      expect(cleaner).to receive(:destroy_time_tables_after)
      expect(cleaner).to receive(:destroy_time_tables_dates_after)
      expect(cleaner).to receive(:destroy_time_tables_periods_after)
      cleaner.clean
    end

    it 'should call destroy_time_tables_between' do
      cleaner.date_type = :between
      expect(cleaner).to receive(:destroy_time_tables_between)
      expect(cleaner).to receive(:destroy_time_tables_dates_between)
      expect(cleaner).to receive(:destroy_time_tables_periods_between)
      cleaner.clean
    end
  end

  context '#destroy_time_tables_dates_between' do
    let!(:time_table) { create(:time_table) }
    let(:cleaner) { create(:clean_up, date_type: :between) }

    before do
      time_table.periods.clear
      time_table.save
      cleaner.begin_date = time_table.start_date
      cleaner.end_date   = time_table.end_date
    end

    it 'should destroy record' do
      expect{ cleaner.destroy_time_tables_dates_between }.to change {
        Chouette::TimeTableDate.count
      }.by(-time_table.dates.count)
    end

    it 'should not destroy record not in range' do
      cleaner.begin_date = time_table.end_date + 1.day
      cleaner.end_date   = cleaner.begin_date + 1.day

      expect{ cleaner.destroy_time_tables_dates_between }.to_not change {
        Chouette::TimeTableDate.count
      }
    end
  end

  context '#destroy_time_tables_dates_after' do
    let!(:time_table_date) { create(:time_table_date, date: Date.yesterday, in_out: true) }
    let(:cleaner) { create(:clean_up, date_type: :after, begin_date: time_table_date.date) }

    it 'should destroy record' do
      count = Chouette::TimeTableDate.where('date >= ?', cleaner.begin_date).count
      expect{ cleaner.destroy_time_tables_dates_after }.to change {
        Chouette::TimeTableDate.count
      }.by(-count)
    end
  end

  context '#destroy_time_tables_between' do
    let!(:time_table) { create(:time_table ) }
    let(:cleaner) { create(:clean_up, date_type: :after, begin_date: time_table.start_date, end_date: time_table.end_date) }

    it 'should destroy time_tables with validity period in purge range' do
      expect{ cleaner.destroy_time_tables_between }.to change {
        Chouette::TimeTable.count
      }.by(-1)
    end

    it 'should not destroy time_tables if not totaly inside purge range' do
      cleaner.begin_date = time_table.start_date + 1.day
      expect{ cleaner.destroy_time_tables_between }.to_not change {
        Chouette::TimeTable.count
      }
    end
  end

  context '#destroy_time_tables_after' do
    let!(:time_table) { create(:time_table ) }
    let(:cleaner) { create(:clean_up, date_type: :after, begin_date: time_table.start_date) }

    it 'should destroy time_tables with start_date >= purge begin_date' do
      expect{ cleaner.destroy_time_tables_after }.to change {
        Chouette::TimeTable.count
      }.by(-1)
    end

    it 'should not destroy time_tables with start_date < purge begin date' do
      cleaner.begin_date = time_table.end_date
      expect{ cleaner.destroy_time_tables_after }.to_not change {
        Chouette::TimeTable.count
      }
    end
  end

  context '#destroy_time_tables' do
    let!(:time_table) { create(:time_table) }
    let(:cleaner) { create(:clean_up, date_type: :before) }

    it 'should destroy all time_tables' do
      expect{cleaner.destroy_time_tables(Chouette::TimeTable.all)}.to change {
        Chouette::TimeTable.count
      }.by(-1)
    end

    it 'should destroy associated vehicle_journeys' do
      create(:vehicle_journey, time_tables: [time_table])
      expect{cleaner.destroy_time_tables(Chouette::TimeTable.all)}.to change {
        Chouette::VehicleJourney.count
      }.by(-1)
    end
  end

  context '#destroy_time_tables_before' do
    let!(:time_table) { create(:time_table ) }
    let(:cleaner) { create(:clean_up, date_type: :before, begin_date: time_table.end_date) }

    it 'should destroy time_tables with end_date <= purge begin_date' do
      expect{ cleaner.destroy_time_tables_before }.to change {
        Chouette::TimeTable.count
      }.by(-1)
    end

    it 'should not destroy time_tables with end_date > purge begin date' do
      cleaner.begin_date = Date.today
      expect{ cleaner.destroy_time_tables_before }.to_not change {
        Chouette::TimeTable.count
      }
    end
  end
end
