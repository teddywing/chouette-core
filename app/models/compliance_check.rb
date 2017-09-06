class ComplianceCheck < ActiveRecord::Base
  belongs_to :compliance_check_set
  belongs_to :compliance_check_block

  enum criticity: [:info, :warning, :error]
  validates :criticity, presence: true
  validates :name, presence: true
  validates :code, presence: true
end
