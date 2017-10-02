class ComplianceControlBlock < ActiveRecord::Base
  extend StifTransportModeEnumerations
  extend StifTransportSubmodeEnumerations

  belongs_to :compliance_control_set
  has_many :compliance_controls, dependent: :destroy

  hstore_accessor :condition_attributes, 
    transport_mode: :string, 
    transport_submode: :string

  validates_presence_of :transport_mode
end
