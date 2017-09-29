class ComplianceControlBlock < ActiveRecord::Base
  belongs_to :compliance_control_set
  has_many :compliance_controls, dependent: :destroy

  hstore_accessor :condition_attributes, 
    transport_mode: :string, 
    transport_submode: :string

    validates_presence_of :transport_mode

  def self.transport_modes
    StifTransportModeEnumerations.transport_modes
  end

  def self.transport_submodes
    StifTransportSubmodeEnumerations.transport_submodes
  end
end
