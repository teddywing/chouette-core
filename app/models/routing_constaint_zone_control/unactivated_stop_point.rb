module RoutingConstaintZoneControl
  class UnactivatedStopPoint < ComplianceControl

    @@default_criticity = :warning
    @@default_code = "3-ITL-1"

    after_initialize do
      self.name = self.class.name
      self.code = @@default_code
      self.criticity = @@default_criticity
    end
  end
end
