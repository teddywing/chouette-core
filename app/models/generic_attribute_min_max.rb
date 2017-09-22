class GenericAttributeMinMax < ComplianceControl


  hstore_accessor :control_attributes, minimum: :integer, maximum: :integer
  #attribute :minimum, type: :integer, optionnal: true
  #attribute :maximum, type: :integer, optionnal: true
  #attribute :target, type: ModelAttribute

  @@default_criticity = :warning
  @@default_code = "3-Generic-2"

  validate :min_max_values
  def min_max_values
    true
  end

  after_initialize do
    self.name = 'GenericAttributeMinMax'
    self.code = @@default_code
    self.criticity = @@default_criticity
  end

end
