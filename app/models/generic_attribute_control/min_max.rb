module GenericAttributeControl
  class MinMax < ComplianceControl
    store_accessor :control_attributes, :minimum, :maximum, :target

    validates :minimum, numericality: true, allow_nil: true
    validates :maximum, numericality: true, allow_nil: true
    validates :target, presence: true
    include MinMaxValuesValidation

    class << self
      def attribute_type; :integer end
      def default_code; "3-Generic-2" end
    end
  end
end
