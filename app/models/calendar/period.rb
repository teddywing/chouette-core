class Calendar::Period
  include ActiveAttr::Model

  attribute :id, type: Integer
  attribute :begin, type: Date
  attribute :end, type: Date

  validate :check_end_greather_than_begin
  validates_presence_of :begin, :end
  validate :validate_dates

  def initialize(args={})
    super
    self.begin = Calendar::CalendarDate.from_date(self.begin) if Date === self.begin
    self.end = Calendar::CalendarDate.from_date(self.end) if Date === self.end
  end

  def check_end_greather_than_begin
    if self.begin and self.end and self.begin > self.end
      errors.add(:end, :invalid)
    end
  end

  def self.from_range(index, range)
    new \
      id:    index, 
      begin: Calendar::CalendarDate.from_date(range.begin), 
      end:   Calendar::CalendarDate.from_date(range.end)
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

  def validate_dates
    validate_begin
    validate_end
  end

  def validate_begin
    errors.add(:begin, I18n.t('activerecord.errors.models.calendar.attributes.dates.illegal_date', date: self.begin.to_s)) unless self.begin.try( :legal? )
  end

  def validate_end
    errors.add(:end, I18n.t('activerecord.errors.models.calendar.attributes.dates.illegal_date', date: self.end.to_s)) unless self.end.try( :legal? )
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

