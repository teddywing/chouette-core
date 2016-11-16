class Workbench < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :line_referential
  belongs_to :stop_area_referential

  has_many :lines, -> (workbench) { Stif::MyWorkbenchScopes.new(workbench).line_scope(self) }, through: :line_referential
  has_many :networks, through: :line_referential
  has_many :companies, through: :line_referential
  has_many :group_of_lines, through: :line_referential
  has_many :stop_areas, through: :stop_area_referential

  validates :name, presence: true
  validates :organisation, presence: true

  has_many :referentials
  has_many :referential_metadatas, through: :referentials
end
