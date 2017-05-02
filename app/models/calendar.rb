class Calendar < ActiveRecord::Base
  belongs_to :organisation
  has_many :time_tables

  validates_presence_of :name, :short_name, :organisation
  validates_uniqueness_of :short_name

  after_initialize :init_dates_and_date_ranges

  scope :contains_date, ->(date) { where('date ? = any (dates) OR date ? <@ any (date_ranges)', date, date) }

  def init_dates_and_date_ranges
    self.dates ||= []
    self.date_ranges ||= []
  end

  def self.ransackable_scopes(auth_object = nil)
    [:contains_date]
  end

  class Period
    include ActiveAttr::Model

    attribute :id, type: Integer
    attribute :begin, type: Date
    attribute :end, type: Date

    validates_presence_of :begin, :end
    validate :check_end_greather_than_begin

    def check_end_greather_than_begin
      if self.begin and self.end and self.begin > self.end
        errors.add(:end, :invalid)
      end
    end

    def self.from_range(index, range)
      Period.new id: index, begin: range.begin, end: range.end
    end

    def range
      if self.begin and self.end and self.begin <= self.end
        Range.new self.begin, self.end
      end
    end

    def intersect?(*other)
      return false if range.nil?

      other = other.flatten
      other = other.delete_if { |o| o.id == id } if id

      other.any? do |period|
        if other_range = period.range
          (range & other_range).present?
        end
      end
    end

    def cover? date
      range.cover? date
    end

    # Stuff required for coocon
    def new_record?
      !persisted?
    end

    def persisted?
      id.present?
    end

    def mark_for_destruction
      self._destroy = true
    end

    attribute :_destroy, type: Boolean
    alias_method :marked_for_destruction?, :_destroy
  end

  # Required by coocon
  def build_period
    Period.new
  end

  def periods
    @periods ||= init_periods
  end

  def init_periods
    if date_ranges
      date_ranges.each_with_index.map { |r, index| Period.from_range(index, r) }
    else
      []
    end
  end
  private :init_periods

  validate :validate_periods

  def validate_periods
    periods_are_valid = true

    unless periods.all?(&:valid?)
      periods_are_valid = false
    end

    periods.each do |period|
      if period.intersect?(periods)
        period.errors.add(:base, I18n.t('calendars.errors.overlapped_periods'))
        periods_are_valid = false
      end
    end

    unless periods_are_valid
      errors.add(:periods, :invalid)
    end
  end

  def periods_attributes=(attributes = {})
    @periods = []
    attributes.each do |index, period_attribute|
      period = Period.new(period_attribute.merge(id: index))
      @periods << period unless period.marked_for_destruction?
    end

    date_ranges_will_change!
  end

  before_validation :fill_date_ranges

  def fill_date_ranges
    if @periods
      self.date_ranges = @periods.map(&:range).compact.sort_by(&:begin)
    end
  end

  after_save :clear_periods

  def clear_periods
    @periods = nil
  end

  private :clear_periods

### dates

  class DateValue
    include ActiveAttr::Model

    attribute :id, type: Integer
    attribute :value, type: Date

    validates_presence_of :value

    def self.from_date(index, date)
      DateValue.new id: index, value: date
    end

    # Stuff required for coocon
    def new_record?
      !persisted?
    end

    def persisted?
      id.present?
    end

    def mark_for_destruction
      self._destroy = true
    end

    attribute :_destroy, type: Boolean
    alias_method :marked_for_destruction?, :_destroy
  end

  # Required by coocon
  def build_date_value
    DateValue.new
  end

  def date_values
    @date_values ||= init_date_values
  end

  def init_date_values
    if dates
      dates.each_with_index.map { |d, index| DateValue.from_date(index, d) }
    else
      []
    end
  end
  private :init_date_values

  validate :validate_date_values

  def validate_date_values
    date_values_are_valid = true

    unless date_values.all?(&:valid?)
      date_values_are_valid = false
    end

    date_values.each do |date_value|
      if date_values.count { |d| d.value == date_value.value } > 1
        date_value.errors.add(:base, I18n.t('activerecord.errors.models.calendar.attributes.dates.date_in_dates'))
        date_values_are_valid = false
      end
      date_ranges.each do |date_range|
        if date_range.cover? date_value.value
          date_value.errors.add(:base, I18n.t('activerecord.errors.models.calendar.attributes.dates.date_in_date_ranges'))
          date_values_are_valid = false
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
      date_value = DateValue.new(date_value_attribute.merge(id: index))
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
