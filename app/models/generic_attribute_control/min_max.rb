module GenericAttributeControl
  class MinMax < ComplianceControl

    class << self
      def attribute_type; :integer end
      def default_code; "3-Generic-2" end
    end

    hstore_accessor :control_attributes, minimum: :integer, maximum: :integer, target: :string

    validate def numericality
      validate_numericality_of :minimum
    end
    validates :minimum, numericality: true, allow_nil: true
    validates :maximum, numericality: true, allow_nil: true
    validates :target, presence: true
    include MinMaxValuesValidation


    def minimum= new_value
      case new_value
      when String
        control_attributes['minimum'] = cast_to_int(:minimum, new_value)
      else
        super()
      end
    end
    

    private
    
    def cast_to_int(field, value)
      return Integer(value)
    rescue ArgumentError
      value
    end

    def validate_numericality_of *atts
      atts.each(&method(:validate_numericality_of_attribute))
    end

    def validate_numericality_of_attribute attr
      send(attr).tap do | value |
        return true if %r{^\a\s*[-+]?\d+\s*\z} === value
        errors.add(attr, "NaN")
      end
    end

  end
end
