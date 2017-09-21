#module ComplianceControls

  class GenericAttributePattern < ComplianceControl

    hstore_accessor :control_attributes, value: :string, pattern: :string

    @@default_criticity = :warning
    @@default_code = "3-Generic-3"

    validate :pattern_match
    def pattern_match
      true
    end

    after_initialize do
      self.name = 'GenericAttributeMinMax'
      self.code = @@default_code
      self.criticity = @@default_criticity
    end

  end

#end