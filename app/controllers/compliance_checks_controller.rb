class ComplianceChecksController <  InheritedResources::Base
  belongs_to :workbench do
    belongs_to :compliance_check_set
  end
end
