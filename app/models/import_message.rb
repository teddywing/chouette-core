class ImportMessage < ActiveRecord::Base
  belongs_to :import
  belongs_to :resource, class_name: ImportResource, dependent: :destroy
  enum criticity: [:info, :warning, :error]

  validates :criticity, presence: true
end
