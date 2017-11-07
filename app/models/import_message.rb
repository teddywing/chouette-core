class ImportMessage < ActiveRecord::Base
  extend Enumerize
  belongs_to :import
  belongs_to :resource, class_name: ImportResource
  enumerize :criticity, in: %i(info warning error)

  validates :criticity, presence: true
end
