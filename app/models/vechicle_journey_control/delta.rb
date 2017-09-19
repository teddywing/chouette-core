module VehicleJourneyControl
  class Delta < ComplianceControl

    hstore_accessor :control_attributes, delta: :integer

    @@default_criticity = :warning
    @@default_code = "3-VehicleJourney-3"

    after_initialize do
      self.name = self.class.name
      self.code = @@default_code
      self.criticity = @@default_criticity
    end
  end
end
