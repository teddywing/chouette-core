class ComplianceCheckBlock < ActiveRecord::Base
  belongs_to :compliance_check_set

  has_many :compliance_checks
end
