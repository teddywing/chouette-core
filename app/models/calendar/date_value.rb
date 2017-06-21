class Calendar::DateValue
  include ActiveAttr::Model

  attribute :id, type: Integer
  attribute :value, type: Date

  validates_presence_of :value
  validate :validate_date
  
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

  def validate_date
    errors.add(:value, I18n.t('activerecord.errors.models.calendar.attributes.dates.illegal_date', date: value.to_s)) unless value.legal? 
  end

  attribute :_destroy, type: Boolean
  alias_method :marked_for_destruction?, :_destroy
end
