class ComplianceCheckResource < ActiveRecord::Base
  extend Enumerize
  belongs_to :compliance_check_set

  enumerize :status, in: %w[new successful warning failed]

  validates_presence_of :compliance_check_set
end
