class ComplianceControlBlock < ActiveRecord::Base
  include StifTransportModeEnumerations
  include StifTransportSubmodeEnumerations

  belongs_to :compliance_control_set
  has_many :compliance_controls, dependent: :destroy

  hstore_accessor :condition_attributes,
    transport_mode: :string,
    transport_submode: :string

  validates :transport_mode, presence: true
  validates :compliance_control_set, presence: true

end
