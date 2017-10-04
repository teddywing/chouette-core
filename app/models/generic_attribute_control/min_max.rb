module GenericAttributeControl
  class MinMax < ComplianceControl
    hstore_accessor :control_attributes, minimum: :integer, maximum: :integer, target: :string

    validate :min_max_values
    def min_max_values
      true
    end

    class << self
      def attribute_type; :integer end
      def default_criticity; :warning end
      def default_code; "3-Generic-2" end
    end
  end
end
