module DateSupport
  extend ActiveSupport::Concern

  included do
    after_initialize :init_dates

    def init_dates
      self.dates ||= []
    end

    ### Calendar::DateValue
    # Required by coocon
    def build_date_value
      Calendar::DateValue.new
    end

    def date_values
      @date_values ||= init_date_values
    end

    def init_date_values
      if dates
        dates.each_with_index.map { |d, index| Calendar::DateValue.from_date(index, d) }
      else
        []
      end
    end
    private :init_date_values

    validate :validate_date_values

    def validate_date_values
      date_values_are_valid = date_values.all?(&:valid?)

      date_values.each do |date_value|
        if date_values.count { |d| d.value == date_value.value } > 1
          date_value.errors.add(:base, I18n.t('activerecord.errors.models.calendar.attributes.dates.date_in_dates'))
          date_values_are_valid = false
        end
        date_ranges.each do |date_range|
          if date_range.cover?(date_value.value)
            excluded_day = self.respond_to?(:valid_day?) && !self.valid_day?(date_value.value.wday)
            unless excluded_day
              date_value.errors.add(:base, I18n.t('activerecord.errors.models.calendar.attributes.dates.date_in_date_ranges'))
              date_values_are_valid = false
            end
          end
        end
      end

      unless date_values_are_valid
        errors.add(:date_values, :invalid)
      end
    end

    def date_values_attributes=(attributes = {})
      @date_values = []
      attributes.each do |index, date_value_attribute|
        date_value_attribute['value'] = flatten_date_array(date_value_attribute, 'value')
        date_value = Calendar::DateValue.new(date_value_attribute.merge(id: index))
        @date_values << date_value unless date_value.marked_for_destruction?
      end

      dates_will_change!
    end

    before_validation :fill_dates

    def fill_dates
      if @date_values
        self.dates = @date_values.map(&:value).compact.sort
      end
    end

    after_save :clear_date_values

    def clear_date_values
      @date_values = nil
    end

    private :clear_date_values
  end
end
