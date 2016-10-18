class Workbench < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :line_referential
  belongs_to :stop_area_referential

  validates :name, presence: true
  validates :organisation, presence: true

  has_many :referentials

end
