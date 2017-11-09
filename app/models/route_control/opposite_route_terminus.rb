module RouteControl
  class OppositeRouteTerminus < ComplianceControl

    def self.default_code; "3-Route-5" end

    def self.prerequisite; I18n.t("compliance_controls.#{self.name.underscore}.prerequisite") end     
  end
end
