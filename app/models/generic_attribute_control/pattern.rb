module GenericAttributeControl
  class Pattern < ComplianceControl
    hstore_accessor :control_attributes, value: :string, pattern: :string

    @@default_criticity = :warning
    @@default_code = "3-Generic-3"

    validate :pattern_match
    def pattern_match
      true
    end
  end
end