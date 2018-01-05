module GenericAttributeControl
  class MinMax < ComplianceControl
    store_accessor :control_attributes, :minimum, :maximum, :target

    validates_numericality_of :minimum, allow_nil: true, greater_than_or_equal_to: 0
    validates_numericality_of :maximum, allow_nil: true, greater_than_or_equal_to: 0
    validates :target, presence: true
    include MinMaxValuesValidation

    class << self
      def attribute_type; :integer end
      def default_code; "3-Generic-2" end
    end
  end
end
