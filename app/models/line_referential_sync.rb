class LineReferentialSync < ActiveRecord::Base
  belongs_to :line_referential
  after_create :synchronize

  private
  def synchronize
    LineReferentialSyncWorker.perform_async(self.id)
  end
end
