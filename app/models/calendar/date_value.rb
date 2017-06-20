class Calendar::DateValue
  include ActiveAttr::Model

  attribute :id, type: Integer
  attribute :value, type: Date

  validate :validate
  
  def initialize(atts={})
    super( atts.slice(:id, :value) )
    # date stored for error message
    @date = atts.slice(*%w{value(3i) value(2i) value(1i)}).values.join("/") 
  end

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

  def validate
    errors.add(:value, "Illegal Date #{@date}") if value.blank?
  end

  attribute :_destroy, type: Boolean
  alias_method :marked_for_destruction?, :_destroy
end
