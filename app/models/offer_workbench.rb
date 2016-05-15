class OfferWorkbench < ActiveRecord::Base
  belongs_to :organisation

  validates :name, presence: true, uniqueness: true
  validates :organisation, presence: true

  has_many :referentials

end
