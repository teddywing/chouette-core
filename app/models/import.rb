class Import < ActiveRecord::Base
  mount_uploader :file, ImportUploader
  belongs_to :workbench
  belongs_to :referential

  extend Enumerize
  enumerize :status, in: %i(new downloading analyzing pending successful failed running aborted canceled)

  validates :file, presence: true

  before_create do
    self.token_download = SecureRandom.urlsafe_base64
    self.status = Import.status.new
  end
end
