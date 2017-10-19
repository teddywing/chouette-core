module GenericAttributeControl
  class Pattern < ComplianceControl
    hstore_accessor :control_attributes, pattern: :string, target: :string

    validates :target, presence: true
    validates :pattern, presence: true

    class << self
      def attribute_type; :string end
      def default_code; "3-Generic-1" end
    end
  end
end
