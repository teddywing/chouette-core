RSpec.describe Calendar::DateValue, type: :model do
  describe 'DateValue' do
    subject { date_value }

    def date_value(attributes = {})
      @__date_values__ ||= Hash.new
      @__date_values__.fetch(attributes) do
        @__date_values__[attributes] = Calendar::DateValue.new(attributes)
      end
    end

    it 'should support mark_for_destruction (required by cocoon)' do
      date_value.mark_for_destruction
      expect(date_value).to be_marked_for_destruction
    end

    it 'should support _destroy attribute (required by coocon)' do
      date_value._destroy = true
      expect(date_value).to be_marked_for_destruction
    end

    it 'should support new_record? (required by cocoon)' do
      expect(Calendar::DateValue.new).to be_new_record
      expect(date_value(id: 42)).not_to be_new_record
    end

    it 'should cast value as date attribute' do
      expect(date_value(value: '2017-01-03').value).to eq(Date.new(2017,01,03))
    end

    it 'validates presence' do
      is_expected.to validate_presence_of(:value)
    end
  end
end
