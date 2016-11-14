class LineReferentialSyncMessage < ActiveRecord::Base
  belongs_to :line_referential_sync
  enum criticity: [:info, :warning, :danger]

  validates :criticity, presence: true
end
