class LineReferential < ActiveRecord::Base
  has_many :line_referential_memberships
  has_many :organisations, through: :line_referential_memberships

  has_many :lines, class_name: 'Chouette::Line'
  has_many :group_of_lines, class_name: 'Chouette::GroupOfLine'

  has_one :line_referential_sync

  def add_member(organisation, options = {})
    attributes = options.merge organisation: organisation
    line_referential_memberships.build attributes
  end

  validates :name, presence: true
  validates :sync_interval, presence: true
  # need to define precise validation rules
  validates_inclusion_of :sync_interval, :in => 1..30
end
