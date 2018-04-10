class ComplianceCheck < ApplicationModel
  include ComplianceItemSupport

  self.inheritance_column = nil

  extend Enumerize
  belongs_to :compliance_check_set
  belongs_to :compliance_check_block

  enumerize :criticity, in: %i(warning error), scope: true, default: :warning
  validates :criticity, presence: true
  validates :name, presence: true
  validates :code, presence: true
  validates :origin_code, presence: true

  def control_class
    compliance_control_name.present? ? compliance_control_name.constantize : nil
  end

  delegate :predicate, to: :control_class, allow_nil: true
  delegate :prerequisite, to: :control_class, allow_nil: true

end
