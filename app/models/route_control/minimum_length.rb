module RouteControl
  class MinimumLength < ComplianceControl
    enumerize :criticity, in: %i(error), scope: true

    def self.default_code; "3-Route-6" end
  end
end
