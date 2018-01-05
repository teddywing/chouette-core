require 'rails_helper'

RSpec.describe CleanUp, :type => :model do
  subject{ build(:clean_up, mode: mode) }
  let(:referential){ Referential.first }

  context "for automatic cleanups" do
    let(:mode){ :auto }
    let(:referential){ create(:referential, :with_metadatas) }

    it { should validate_presence_of(:referential).with_message(:presence) }
    it { should validate_presence_of(:mode).with_message(:presence) }
    it { should belong_to(:referential) }

    let(:periode_1){ 1.day.from_now..10.days.from_now }
    let(:periode_2){ 20.day.from_now..30.days.from_now }
    let(:periode_3){ 40.day.from_now..50.days.from_now }
    let(:periodes){ [periode_1, periode_2, periode_3] }

    let(:cleaner) { create(:clean_up, mode: mode, referential: referential) }
    let(:time_table) { create(:time_table) }
    let(:period) { time_table.periods[0] }

    before(:each) do
      metadata = referential.metadatas.first
      metadata.periodes = periodes
    end

    context '#overlapping_periods' do
      let(:periodes) { [periode_1] }

      context "with overlapping periods" do
        let(:periode_1) { period.period_start..period.period_end }

        it 'should detect overlapping periods' do
          expect(cleaner.overlapping_periods).to include(time_table.periods[0])
        end
      end

      context "without overlapping periods" do
        let(:periode_1) { period.period_end+1.day..period.period_end+2.days }

        it 'should not return non-overlapping periods' do
          expect(cleaner.overlapping_periods).to_not include(time_table.periods[0])
        end
      end
    end

    context '#exclude_dates_in_overlapping_period' do
      context "with a fully overlapping period" do
        let(:periode_1) { period.period_start..period.period_end }
        it 'should exclude no date' do
          expect { cleaner.exclude_dates_in_overlapping_period(period) }.to change {
            time_table.dates.where(in_out: false).count
          }.by(0)
        end
      end

      context "with 2 partially overlapping periods" do
        let(:periode_1) { period.period_start-10.days..period.period_start+1.day }
        let(:periode_2) { period.period_end-1.day..period.period_end+10.days }
        it 'should exclude only the no-overlapping dates' do
          count = (period.period_start..period.period_end).count
          count -= 4 # 4 overlapping days, 2 at the beginning, 2 at the end
          expect { cleaner.exclude_dates_in_overlapping_period(period) }.to change {
            time_table.dates.where(in_out: false).count
          }.by(count)
        end
      end

      context "without overlapping periods" do
        let(:periode_1) { period.period_end+1.day..period.period_end+2.days }
        let(:periodes) { [periode_1] }

        it 'should exclude all the dates' do
          expect { cleaner.exclude_dates_in_overlapping_period(period) }.to change {
            time_table.dates.where(in_out: false).count
          }.by((period.period_start..period.period_end).count)
        end
      end
    end

    context '#clean' do
      let(:cleaner) { create(:clean_up, date_type: :before, mode: mode, referential: referential) }

      it 'should call destroy_time_tables_before' do
        expect(cleaner).to receive(:destroy_time_tables_based_on_referential)
        expect(cleaner).to receive(:destroy_time_tables_dates_based_on_referential)
        expect(cleaner).to receive(:destroy_time_tables_periods_based_on_referential)
        expect(cleaner).to receive(:destroy_lines_related_objects_based_on_referential)
        cleaner.clean
      end
    end

    context '#destroy_time_tables_dates_based_on_referential' do
      let(:periodes) { [periode_1, periode_2, periode_3].compact }
      let(:periode_3){ nil }

      let(:time_table) do
        time_table = create :time_table
        time_table.periods.clear
        time_table.save
        time_table
      end

      context "for non-overlapping periods" do
        let(:periode_1) { time_table.end_date+1.day..time_table.end_date+2.days}
        let(:periode_2) { time_table.start_date-2.days..time_table.start_date-1.day}
        it 'should destroy record' do
          expect{ cleaner.destroy_time_tables_dates_based_on_referential }.to change {
            Chouette::TimeTableDate.count
          }.by(- time_table.dates.count)
        end
      end

      context "for overlapping periods" do
        let(:periode_1) { time_table.end_date-1.day..time_table.end_date+2.days}
        let(:periode_2) { time_table.end_date+1000.days..time_table.end_date+1100.days}
        let(:periode_2) { time_table.start_date-1100.days..time_table.start_date-1000.days}
        it 'should destroy record' do
          expect{ cleaner.destroy_time_tables_dates_based_on_referential }.to change {
            Chouette::TimeTableDate.count
          }.by(2 - time_table.dates.count)
        end
      end

      context "for fully overlapping periods" do
        let(:periode_1) { time_table.start_date..time_table.end_date}
        let(:periode_2) { time_table.end_date+1000.days..time_table.end_date+1100.days}
        it 'should destroy record' do
          expect{ cleaner.destroy_time_tables_dates_based_on_referential }.to change {
            Chouette::TimeTableDate.count
          }.by(0)
        end
      end
    end

    context '#destroy_time_tables_periods_based_on_referential' do
      let(:periodes) { [periode_1, periode_2, periode_3].compact }
      let(:periode_2){ nil }
      let(:periode_3){ nil }
      let(:period){ create :time_table_period }
      before do
        Chouette::TimeTablePeriod.where.not(id: period.id).delete_all
      end

      context "with overlapping metadata period" do
        let(:periode_1){ period.period_start-1.day..period.period_start }
        it 'should not destroy record' do
          expect{ cleaner.destroy_time_tables_periods_based_on_referential }.to change {
            Chouette::TimeTablePeriod.count
          }.by(0)
        end
      end

      context "without overlapping metadata period" do
        let(:periode_1){ period.period_start-10.days..period.period_start-1.day }
        let(:periode_2){ period.period_end+1.day..period.period_end+10.days }
        it 'should destroy record' do
          expect{ cleaner.destroy_time_tables_periods_based_on_referential }.to change {
            Chouette::TimeTablePeriod.count
          }.by(-1)
        end
      end
    end
  end

  context "for manual cleanups" do
    let(:mode){ :manual }

    it { should validate_presence_of(:date_type).with_message(:presence) }
    it { should validate_presence_of(:begin_date).with_message(:presence) }
    it { should validate_presence_of(:referential).with_message(:presence) }
    it { should validate_presence_of(:mode).with_message(:presence) }
    it { should belong_to(:referential) }

    context 'Clean Up With Date Type : Between' do
      subject(:cleaner) { create(:clean_up, date_type: :between, mode: mode, referential: referential) }
      it { should validate_presence_of(:end_date).with_message(:presence) }

      it 'should have a end date strictly greater than the begin date' do
        expect(cleaner).to be_valid

        cleaner.end_date = cleaner.begin_date
        expect(cleaner).not_to be_valid
      end
    end

    context '#exclude_dates_in_overlapping_period with :before date_type' do
      let(:time_table) { create(:time_table) }
      let(:period) { time_table.periods[0] }
      let(:cleaner) { create(:clean_up, date_type: :before, begin_date: period.period_end, mode: mode, referential: referential) }

      it 'should add exclude date into period for overlapping period' do
        days_in_period = (period.period_start..period.period_end).count

        expect { cleaner.exclude_dates_in_overlapping_period(period) }.to change {
          time_table.dates.where(in_out: false).count
        }.by(days_in_period - 1)
      end

      it 'should not add exclude date if no overlapping found' do
        cleaner.begin_date = period.period_start
        expect { cleaner.exclude_dates_in_overlapping_period(period) }.to_not change {
          time_table.dates.where(in_out: false).count
        }
      end
    end

    context '#exclude_dates_in_overlapping_period with :after date_type' do
      let(:time_table) { create(:time_table) }
      let(:period) { time_table.periods[0] }
      let(:cleaner) { create(:clean_up, date_type: :after, begin_date: period.period_start + 1.day, mode: mode, referential: referential) }

      it 'should add exclude date into period for overlapping period' do
        days_in_period = (period.period_start..period.period_end).count
        expect { cleaner.exclude_dates_in_overlapping_period(period) }.to change {
          time_table.dates.where(in_out: false).count
        }.by(days_in_period - 2)
      end

      it 'should not add exclude date if no overlapping found' do
        cleaner.begin_date = period.period_end
        expect { cleaner.exclude_dates_in_overlapping_period(period) }.to_not change {
          time_table.dates.where(in_out: false).count
        }
      end
    end

    context '#exclude_dates_in_overlapping_period with :between date_type' do
      let(:time_table) { create(:time_table) }
      let(:period) { time_table.periods[0] }
      let(:cleaner) { create(:clean_up, date_type: :between, begin_date: period.period_start + 3.day, end_date: period.period_end, mode: mode, referential: referential) }

      it 'should add exclude date into period for overlapping period' do

        expected_day_out = (cleaner.begin_date..cleaner.end_date).count
        expect { cleaner.exclude_dates_in_overlapping_period(period) }.to change {
          time_table.dates.where(in_out: false).count
        }.by(expected_day_out - 2)
      end

      it 'should not add exclude date if no overlapping found' do
        cleaner.begin_date = period.period_end  + 1.day
        cleaner.end_date   = cleaner.begin_date + 1.day

        expect { cleaner.exclude_dates_in_overlapping_period(period) }.to_not change {
          time_table.dates.where(in_out: false).count
        }
      end
    end

    context '#overlapping_periods' do
      let(:time_table) { create(:time_table) }
      let(:period) { time_table.periods[0] }
      let(:cleaner) { create(:clean_up, date_type: :before, begin_date: period.period_start, mode: mode, referential: referential) }

      it 'should detect overlapping periods' do
        expect(cleaner.overlapping_periods).to include(time_table.periods[0])
      end

      it 'should not return non-overlapping periods' do
        cleaner.begin_date = time_table.periods[0].period_start - 1.day
        expect(cleaner.overlapping_periods).to_not include(time_table.periods[0])
      end
    end

    context '#clean' do
      let(:cleaner) { create(:clean_up, date_type: :before, mode: mode, referential: referential) }

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
      let(:cleaner) { create(:clean_up, date_type: :between, mode: mode, referential: referential) }

      before do
        time_table.periods.clear
        time_table.save
        cleaner.begin_date = time_table.start_date
        cleaner.end_date   = time_table.end_date
      end

      it 'should destroy record' do
        expect{ cleaner.destroy_time_tables_dates_between }.to change {
          Chouette::TimeTableDate.count
        }.by(-time_table.dates.count + 2)
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
      let(:cleaner) { create(:clean_up, date_type: :after, begin_date: time_table_date.date, mode: mode, referential: referential) }

      it 'should destroy record' do
        count = Chouette::TimeTableDate.where('date > ?', cleaner.begin_date).count
        expect{ cleaner.destroy_time_tables_dates_after }.to change {
          Chouette::TimeTableDate.count
        }.by(-count)
      end
    end

    context '#destroy_time_tables_between' do
      let!(:time_table) { create(:time_table ) }
      let(:cleaner) { create(:clean_up, date_type: :between, begin_date: time_table.start_date - 1.day, end_date: time_table.end_date + 1.day, mode: mode, referential: referential) }

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
      let(:cleaner) { create(:clean_up, date_type: :after, begin_date: time_table.start_date - 1.day, mode: mode, referential: referential) }

      it 'should destroy time_tables with start_date > purge begin_date' do
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
      let(:cleaner) { create(:clean_up, mode: mode, referential: referential) }

      it 'should destroy all time_tables' do
        expect{cleaner.destroy_time_tables(Chouette::TimeTable.all)}.to change {
          Chouette::TimeTable.count
        }.by(-1)
      end

      it 'should destroy time_table vehicle_journey association' do
        vj = create(:vehicle_journey, time_tables: [time_table, create(:time_table)])
        cleaner.destroy_time_tables(Chouette::TimeTable.where(id: time_table.id))

        expect(vj.reload.time_tables.map(&:id)).to_not include(time_table.id)
      end

      it 'should also destroy associated vehicle_journey if it belongs to any other time_table' do
        vj = create(:vehicle_journey, time_tables: [time_table])
        expect{cleaner.destroy_time_tables(Chouette::TimeTable.all)}.to change {
          Chouette::VehicleJourney.count
        }.by(-1)
      end
    end

    context '#destroy_vehicle_journey_without_time_table' do
      let(:cleaner) { create(:clean_up, mode: mode, referential: referential) }

      it 'should destroy vehicle_journey' do
        vj = create(:vehicle_journey)
        expect{cleaner.destroy_vehicle_journey_without_time_table
        }.to change { Chouette::VehicleJourney.count }.by(-1)
      end

      it 'should not destroy vehicle_journey with time_table' do
        create(:vehicle_journey, time_tables: [create(:time_table)])
        expect{cleaner.destroy_vehicle_journey_without_time_table
        }.to_not change { Chouette::VehicleJourney.count }
      end
    end

    context '#destroy_time_tables_before' do
      let!(:time_table) { create(:time_table ) }
      let(:cleaner) { create(:clean_up, date_type: :before, begin_date: time_table.end_date + 1.day, mode: mode, referential: referential) }

      it 'should destroy time_tables with end_date < purge begin_date' do
        expect{ cleaner.destroy_time_tables_before }.to change {
          Chouette::TimeTable.count
        }.by(-1)
      end

      it 'should not destroy time_tables with end_date > purge begin_date' do
        cleaner.begin_date = Date.today
        expect{ cleaner.destroy_time_tables_before }.to_not change {
          Chouette::TimeTable.count
        }
      end
    end
  end
end
