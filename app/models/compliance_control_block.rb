class ComplianceControlBlock < ActiveRecord::Base
  belongs_to :compliance_control_set
  has_many :compliance_controls, dependent: :destroy

  hstore_accessor :condition_attributes, 
    transport_mode: :string, 
    transport_sub_mode: :string

    validates_presence_of :transport_mode

  def self.transport_modes
    StifTransportModeEnumerations.transport_mode.options
  end

  def self.transport_sub_modes
    StifTransportSubmodeEnumerations.transport_submode.options
  end
end
