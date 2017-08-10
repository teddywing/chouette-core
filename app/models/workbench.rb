class Workbench < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :line_referential
  belongs_to :stop_area_referential

  has_many :lines, -> (workbench) { Stif::MyWorkbenchScopes.new(workbench).line_scope(self) }, through: :line_referential
  has_many :networks, through: :line_referential
  has_many :companies, through: :line_referential
  has_many :group_of_lines, through: :line_referential
  has_many :stop_areas, through: :stop_area_referential
  has_many :imports
  has_many :workbench_object_identifiers

  validates :name, presence: true
  validates :organisation, presence: true

  has_many :referentials
  has_many :referential_metadatas, through: :referentials, source: :metadatas


  def all_referentials
    if line_ids.empty?
      Referential.none
    else
      Referential.joins(:metadatas).where(['referential_metadata.line_ids && ARRAY[?]::bigint[]', line_ids]).ready
    end
  end

end
