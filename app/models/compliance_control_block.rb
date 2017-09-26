class ComplianceControlBlock < ActiveRecord::Base
  belongs_to :compliance_control_set
  belongs_to :compliance_control

  before_save :set_compliance_control_set

  hstore_accessor :condition_attributes, transport_mode: :string

  def set_compliance_control_set
    self.compliance_control_set = self.compliance_control.compliance_control_set
  end
end
