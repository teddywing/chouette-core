class Import < ActiveRecord::Base
  mount_uploader :file, ImportUploader
  belongs_to :workbench
  belongs_to :referential

  validates :file, presence: true
end
