module VehicleJourneyControl
  class TimeTable < ComplianceControl

    @@default_criticity = :error
    @@default_code = "3-VehicleJourney-4"

    after_initialize do
      self.name = self.class.name
      self.code = @@default_code
      self.criticity = @@default_criticity
    end
  end
end
