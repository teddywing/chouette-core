class ComplianceControlBlock < ActiveRecord::Base
  extend StifTransportModeEnumerations
  extend StifTransportSubmodeEnumerations

  belongs_to :compliance_control_set
  has_many :compliance_controls, dependent: :destroy

  hstore_accessor :condition_attributes,
    transport_mode: :string,
    transport_submode: :string

  validates :transport_mode, presence: true
  validates :compliance_control_set, presence: true

  def label_method
    [transport_mode, transport_submode].compact.map {|x| "[#{x}]"}.join
  end
end
