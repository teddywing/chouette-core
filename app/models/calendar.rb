class Calendar < ActiveRecord::Base
  belongs_to :organisation

  validates_presence_of :name, :short_name, :organisation
  validates_uniqueness_of :short_name
  validate :date_not_in_date_ranges, :dates_uniqueness

  after_initialize :init_dates_and_date_ranges

  scope :contains_date, ->(date) { where('date ? = any (dates) OR date ? <@ any (date_ranges)', date, date) }

  def init_dates_and_date_ranges
    self.dates ||= []
    self.date_ranges ||= []
  end



  class Period
    include ActiveAttr::Model

    attribute :id, type: Integer
    attribute :begin, type: Date
    attribute :end, type: Date

    validates :begin, :end, presence: true
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
        period.errors.add(:base, I18n.t('calendars.errors.overlapped_period'))
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

  def self.new_from from
    from.dup.tap do |metadata|
      metadata.referential_id = nil
    end
  end

  private
  def date_not_in_date_ranges
    errors.add(:dates, I18n.t('activerecord.errors.models.calendar.attributes.dates.date_in_date_ranges')) if dates && date_ranges && dates_and_date_ranges_overlap?
  end

  def dates_and_date_ranges_overlap?
    overlap = false
    dates.each do |date|
      date_ranges.each do |date_range|
        overlap = true if date_range.cover? date
      end
    end
    overlap
  end

  def dates_uniqueness
    errors.add(:dates, I18n.t('activerecord.errors.models.calendar.attributes.dates.date_in_dates')) if dates && dates.length > dates.uniq.length
  end

  def self.ransackable_scopes(auth_object = nil)
    [:contains_date]
  end
end

class Range
  def intersection(other)
    return nil if (self.max < other.begin or other.max < self.begin)
    [self.begin, other.begin].max..[self.max, other.max].min
  end
  alias_method :&, :intersection
end
