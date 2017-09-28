class ComplianceControlSet < ActiveRecord::Base
  belongs_to :organisation
  has_many :compliance_controls, dependent: :destroy

  validates :name, presence: true
  scope :where_updated_at_between, ->(start_date, end_date) do
    where('updated_at BETWEEN ? AND ?', start_date, end_date)
  end
end
