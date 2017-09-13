class ComplianceCheckSet < ActiveRecord::Base
  extend Enumerize

  belongs_to :referential
  belongs_to :compliance_control_set
  belongs_to :workbench
  belongs_to :parent, polymorphic: true

  enumerize :status, in: %w[new pending successful warning failed running aborted canceled]
end
