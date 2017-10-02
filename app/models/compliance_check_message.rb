class ComplianceCheckMessage < ActiveRecord::Base
  extend Enumerize

  belongs_to :compliance_check_set
  belongs_to :compliance_check
  belongs_to :compliance_check_resource

  enumerize :status, in: %i(OK ERROR WARNING IGNORED), scope: true

  validates_presence_of :compliance_check_set
end
