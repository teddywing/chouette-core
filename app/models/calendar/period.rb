class Calendar::Period
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

