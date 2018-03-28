module MinMaxValuesValidation
  extend ActiveSupport::Concern

  included do
    validates_presence_of :minimum, :maximum
    validates_numericality_of :minimum, :maximum, allow_nil: true, greater_than_or_equal_to: 0
    validates_format_of :minimum, :maximum, with: %r{\A\d+\.\d{2}\Z}
    validate :min_max_values_validation
  end

  def min_max_values_validation
    return true if (minimum && maximum) && (minimum.to_f < maximum.to_f)
    errors.add(:minimum, I18n.t('compliance_controls.min_max_values', min: minimum, max: maximum))
  end
end
