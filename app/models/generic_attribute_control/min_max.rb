module GenericAttributeControl
  class MinMax < ComplianceControl

    class << self
      def attribute_type; :integer end
      def default_code; "3-Generic-2" end
    end

    hstore_accessor :control_attributes, maximum: :integer, target: :string

    validates :minimum, numericality: true, allow_nil: true
    validates :maximum, numericality: true, allow_nil: true
    validates :target, presence: true
    include MinMaxValuesValidation

    def minimum
      control_attributes['_minimum']
    end
    def minimum= new_value
      case new_value
      when String
        control_attributes['_minimum'] = cast_to_int(:minimum, new_value)
      else
        control_attributes['_minimum']= new_value
      end
    end
    

    private
    
    def cast_to_int(field, value)
      return Integer(value)
    rescue ArgumentError
      value
    end

  end
end
