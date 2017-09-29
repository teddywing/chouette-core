module GenericAttributeControl
  class Uniqueness < ComplianceControl
    hstore_accessor :control_attributes, name: :string

    cattr_reader :default_criticity, :default_code
    @@default_criticity = :warning
    @@default_code = "3-Generic-3"

    validate :unique_values
    def unique_values
      true
    end
  end
end
