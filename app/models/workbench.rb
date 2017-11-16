class Workbench < ActiveRecord::Base
  include ObjectidFormatterSupport
  extend Enumerize
  belongs_to :organisation
  belongs_to :line_referential
  belongs_to :stop_area_referential
  belongs_to :output, class_name: 'ReferentialSuite'
  enumerize :objectid_format, in: %w(netex stif_netex stif_reflex stif_codifligne)

  has_many :lines, -> (workbench) { Stif::MyWorkbenchScopes.new(workbench).line_scope(self) }, through: :line_referential
  has_many :networks, through: :line_referential
  has_many :companies, through: :line_referential
  has_many :group_of_lines, through: :line_referential
  has_many :stop_areas, through: :stop_area_referential
  has_many :imports
  has_many :workbench_imports
  has_many :compliance_check_sets
  has_many :compliance_control_sets

  validates :name, presence: true
  validates :organisation, presence: true
  validates :output, presence: true
  validates_presence_of :objectid_format

  has_many :referentials
  has_many :referential_metadatas, through: :referentials, source: :metadatas

  before_validation :initialize_output


  def all_referentials
    if line_ids.empty?
      Referential.none
    else
      Referential.joins(:metadatas).where(['referential_metadata.line_ids && ARRAY[?]::bigint[]', line_ids]).ready
    end
  end

  private

  def initialize_output
    # Don't reset `output` if it's already initialised
    return if !output.nil?

    self.output = ReferentialSuite.create
  end
end
