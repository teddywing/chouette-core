class LineReferentialMembership < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :line_referential

  validates :organisation_id, presence: true, uniqueness: { scope: :line_referential }
end
