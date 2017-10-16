class ComplianceCheck < ActiveRecord::Base

  self.inheritance_column = nil

  extend Enumerize
  belongs_to :compliance_check_set
  belongs_to :compliance_check_block
  
  enumerize :criticity, in: %i(warning error), scope: true, default: :warning
  validates :criticity, presence: true
  validates :name, presence: true
  validates :code, presence: true
  validates :origin_code, presence: true
end
