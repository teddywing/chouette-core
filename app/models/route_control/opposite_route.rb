module RouteControl
  class OppositeRoute < ComplianceControl
    enumerize :criticity, in: %i(error), scope: true, default: :error

    def self.default_code; "3-Route-2" end
  end
end
