module GenericAttributeControl
  class Pattern < ComplianceControl
    hstore_accessor :control_attributes, pattern: :string, target: :string

    validate :pattern_match
    def pattern_match
      true
    end

    class << self
      def attribute_type; :string end
      def default_criticity; :warning end
      def default_code; "3-Generic-3" end
    end
  end
end
