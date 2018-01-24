RSpec.describe Calendar, :type => :model do

  it { should belong_to(:organisation) }

  it { is_expected.to validate_presence_of(:organisation) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:short_name) }
  it { is_expected.to validate_uniqueness_of(:short_name) }
  it { is_expected.to be_versioned }

  describe '#to_time_table' do
    let(:calendar) { create(:calendar, int_day_types: Calendar::MONDAY | Calendar::SUNDAY, date_ranges: [Date.today...(Date.today + 1.month)]) }

    it 'should convert calendar to an instance of Chouette::TimeTable' do
      time_table = calendar.convert_to_time_table
      expect(time_table).to be_an_instance_of(Chouette::TimeTable)
      expect(time_table.int_day_types).to eq calendar.int_day_types
      expect(time_table.periods[0].period_start).to eq(calendar.periods[0].begin)
      expect(time_table.periods[0].period_end).to eq(calendar.periods[0].end)
      expect(time_table.dates.map(&:date)).to match_array(calendar.dates)
    end
  end

  describe 'validations' do
    it 'validates that dates and date_ranges do not overlap' do
      expect(build(:calendar, dates: [Date.today], date_ranges: [Date.today..Date.tomorrow])).to_not be_valid
    end

    it 'validates that there are no duplicates in dates' do
      expect(build(:calendar, dates: [Date.yesterday, Date.yesterday], date_ranges: [Date.today..Date.tomorrow])).to_not be_valid
    end
  end

  describe 'before_validation' do
    let(:calendar) { create(:calendar, date_ranges: []) }

    it 'shoud fill date_ranges with date ranges' do
      expected_range = Date.today..Date.tomorrow
      calendar.date_ranges << expected_range
      calendar.valid?

      expect(calendar.date_ranges.map { |period| period.begin..period.end }).to eq([expected_range])
    end
  end

end
