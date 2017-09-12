class ComplianceControl < ActiveRecord::Base
  belongs_to :compliance_control_set
  belongs_to :compliance_control_block

  enum criticity: [:info, :warning, :error]
  validates :criticity, presence: true
  validates :name, presence: true
  validates :code, presence: true
end
