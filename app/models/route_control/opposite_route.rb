module RouteControl
  class OppositeRoute < ComplianceControl

    @@default_criticity = :error
    @@default_code = "3-Route-2"

    after_initialize do
      self.name = self.class.name
      self.code = @@default_code
      self.criticity = @@default_criticity
    end

  end
end
