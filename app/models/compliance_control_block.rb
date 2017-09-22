class ComplianceControlBlock < ActiveRecord::Base
  belongs_to :compliance_control_set
  belongs_to :compliance_control

  before_save :set_compliance_control_set

  def set_compliance_control_set
    self.compliance_control_set = self.compliance_control.compliance_control_set
  end
end
