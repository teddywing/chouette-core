module VehicleJourneyControl
  class Speed < ComplianceControl

    hstore_accessor :control_attributes, minimum: :integer, maximum: :integer

    @@default_criticity = :warning
    @@default_code = "3-VehicleJourney-2"

    after_initialize do
      self.name = self.class.name
      self.code = @@default_code
      self.criticity = @@default_criticity
    end
  end
end
