class Workgroup < ActiveRecord::Base
  belongs_to :line_referential
  belongs_to :stop_area_referential

  has_many :workbenches

  validates_uniqueness_of :name

  validates_presence_of :line_referential_id
  validates_presence_of :stop_area_referential_id

  def organisations
    workbenches.map(&:organisation)
  end
end
