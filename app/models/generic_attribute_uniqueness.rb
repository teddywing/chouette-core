#module ComplianceControls

  class GenericAttributeUniqueness < ComplianceControl

    hstore_accessor :control_attributes, name: :string

    @@default_criticity = :warning
    @@default_code = "3-Generic-3"

    validate :unique_values
    def unique_values
      true
    end

    after_initialize do
      self.name = 'GenericAttributeMinMax'
      self.code = @@default_code
      self.criticity = @@default_criticity
    end

  end

#end