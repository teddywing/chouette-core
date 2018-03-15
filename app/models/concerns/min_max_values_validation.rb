module MinMaxValuesValidation
  extend ActiveSupport::Concern

  included do
    before_validation :force_min_max_values_to_respect_numeric_format
    validates_presence_of :minimum, :maximum
    validates_numericality_of :minimum, :maximum, allow_nil: true, greater_than_or_equal_to: 0
    validate :min_max_values_validation
  end

  def force_min_max_values_to_respect_numeric_format
    if self.minimum && self.maximum
      self.minimum = self.minimum.gsub(",", ".")
      self.maximum = self.maximum.gsub(",", ".")
    end
  end

  def min_max_values_validation
    return true if (maximum && maximum) && (minimum.to_f < maximum.to_f)
    errors.add(:minimum, I18n.t('compliance_controls.min_max_values', min: minimum, max: maximum))
  end
end
