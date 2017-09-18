class ComplianceCheckMessage < ActiveRecord::Base
  belongs_to :compliance_check
  belongs_to :compliance_check_resource
end
