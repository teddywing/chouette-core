class ReferentialMetadata < ActiveRecord::Base
  belongs_to :referential
  belongs_to :referential_source, class_name: 'Referential'
  has_array_of :lines, class_name: 'Chouette::Line'

  validates :referential, presence: true
  validates :lines, presence: true
  validates :periodes, presence: true

  scope :include_lines, -> (line_ids) { where('line_ids && ARRAY[?]', line_ids) }
  scope :include_dateranges, -> (dateranges) { where('periodes && ARRAY[?]', dateranges) }

  def first_period
    periodes.first if periodes
  end

  def first_period_begin
    @first_period_begin or first_period.try(:begin)
  end
  def first_period_begin=(date)
    periodes_will_change! unless @first_period_begin == date
    @first_period_begin = date
  end
  def first_period_end
    if @first_period_end
      @first_period_end
    else
      if first_period
        date = first_period.end
        date -= 1 if first_period.exclude_end?
        date
      end
    end
  end
  def first_period_end=(date)
    periodes_will_change! unless @first_period_end == date
    @first_period_end = date
  end

  validate :check_first_period_end

  def check_first_period_end
    if @first_period_begin and @first_period_end and @first_period_begin > @first_period_end
      errors.add(:first_period_end, :invalid)
    end
  end

  before_validation :set_first_period

  def set_first_period
    if @first_period_begin and @first_period_end and @first_period_begin <= @first_period_end
      self.periodes ||= []
      self.periodes[0] = Range.new @first_period_begin, @first_period_end
    end
  end

  def column_for_attribute(name)
    if %i{first_period_begin first_period_end}.include?(name.to_sym)
      ActiveRecord::ConnectionAdapters::Column.new(name, nil, "date")
    else
      super name
    end
  end

  def self.new_from from
    from.dup.tap do |metadata|
      metadata.referential_id = nil
    end
  end
end
