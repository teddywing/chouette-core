class GenericAttributeMinMax < ComplianceControl
  hstore_accessor :control_attributes, minimum: :integer, maximum: :integer

  @@default_criticity = :warning
  @@default_code = "3-Generic-2"

  validate :min_max_values

  def min_max_values
    true
  end

  def self.dynamic_attributes
    self.hstore_metadata_for_control_attributes.keys
  end

  # after_initialize do
  #   self.name = 'GenericAttributeMinMax'
  #   self.code = @@default_code
  #   self.criticity = @@default_criticity
  # end

end
