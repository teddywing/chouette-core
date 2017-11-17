module GenericAttributeControl
  class MinMax < ComplianceControl

    class << self
      def attribute_type; :integer end
      def default_code; "3-Generic-2" end
    end

    hstore_accessor :control_attributes, maximum: :integer, target: :string

    validates :maximum, numericality: true, allow_nil: true
    validates :target, presence: true
    include MinMaxValuesValidation


    # BEGIN: Sketching out our own hstore_accessor implementation
    validate def numericality_of_minimum
      _get_minimum.tap do |stored_value|
        return true unless stored_value # allow_nil: true
        return true if %r{\A\s*[-+]?\d+\s*\z} === stored_value
        errors.add(:minimum, 'NaN')
      end
    end
    def minimum= new_value
      stored_value = cast_value(new_value)
      control_attributes['minimum'] = stored_value
    end
    def minimum
      _get_minimum.to_i
    end


    private

    def _get_minimum
      control_attributes.try(:[], 'minimum')
    end
    
    def cast_value(value)
      return nil unless value # Allow for nil in storage, we must not anticipate validation
      value.to_s
    end
    # END: Sketching our own hstore_accessor implementation

  end
end
