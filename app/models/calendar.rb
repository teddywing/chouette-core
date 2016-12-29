class Calendar < ActiveRecord::Base
  belongs_to :organisation

  validates_presence_of :name, :short_name, :organisation
  validates_uniqueness_of :short_name
  validate :date_not_in_date_ranges

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

  class DateRange
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
      DateRange.new id: index, begin: range.begin, end: range.end
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

      other.any? do |date_range|
        if other_range = date_range.range
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
  def build_date_range
    DateRange.new
  end

  def ranges
    @ranges ||= init_ranges
  end

  def init_ranges
    if date_ranges
      date_ranges.each_with_index.map { |r, index| DateRange.from_range(index, r) }
    else
      []
    end
  end
  private :init_ranges

  validate :validate_ranges

  def validate_ranges
    ranges_are_valid = true

    unless ranges.all?(&:valid?)
      ranges_are_valid = false
    end

    ranges.each do |range|
      if range.intersect?(ranges)
        range.errors.add(:base, I18n.t("referentials.errors.overlapped_period"))
        ranges_are_valid = false
      end
    end

    errors.add(:ranges, :invalid) unless ranges_are_valid
  end

  def ranges_attributes=(attributes = {})
    @ranges = []
    attributes.each do |index, range_attribute|
      range = DateRange.new(range_attribute.merge(id: index))
      @ranges << range unless range.marked_for_destruction?
    end

    date_ranges_will_change!
  end

  before_validation :fill_date_ranges

  def fill_date_ranges
    if @ranges
      self.date_ranges = @ranges.map(&:range).compact.sort_by(&:begin)
    end
  end

  after_save :clear_ranges

  def clear_ranges
    @ranges = nil
  end
  private :clear_ranges
end

class Range
  def intersection(other)
    return nil if (self.max < other.begin or other.max < self.begin)
    [self.begin, other.begin].max..[self.max, other.max].min
  end
  alias_method :&, :intersection
end

