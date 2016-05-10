class LineReferential < ActiveRecord::Base
  has_many :line_referential_memberships
  has_many :organisations, through: :line_referential_memberships

  def add_member(organisation, options = {})
    attributes = options.merge organisation: organisation
    line_referential_memberships.build attributes
  end

  validates :name, presence: true
end
