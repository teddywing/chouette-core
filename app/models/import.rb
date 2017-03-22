class Import < ActiveRecord::Base
  mount_uploader :file, ImportUploader
  belongs_to :workbench
  belongs_to :referential

  extend Enumerize
  enumerize :status, in: %i(new pending successful failed canceled)

  validates :file, presence: true

  before_create do
    self.token_download = SecureRandom.urlsafe_base64
  end
end
