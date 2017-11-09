module LineControl
  class Route < ComplianceControl

    def self.default_code; "3-Line-1" end

    def self.prerequisite; I18n.t("compliance_controls.#{self.name.underscore}.prerequisite") end
  end
end
