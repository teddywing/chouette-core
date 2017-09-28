class ComplianceCheckSet < ActiveRecord::Base
  extend Enumerize

  belongs_to :referential
  belongs_to :compliance_control_set
  belongs_to :workbench
  belongs_to :parent, polymorphic: true

  has_many :compliance_check_set

  enumerize :status, in: %w[new pending successful warning failed running aborted canceled]

  scope :where_created_at_between, ->(start_date, end_date) do
    where('created_at BETWEEN ? AND ?', start_date, end_date)
  end

end
