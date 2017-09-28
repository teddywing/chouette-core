class ComplianceControlBlock < ActiveRecord::Base
  belongs_to :compliance_control_set
  has_many :compliance_controls, dependent: :destroy

  hstore_accessor :condition_attributes, transport_mode: :string

  def self.transport_modes
    ["all"] + StifTransportModeEnumerations.transport_mode.values
  end
end
