class LineReferentialSyncWorker
  include Sidekiq::Worker

  def perform(lref_sync_id)
    lref_sync = LineReferentialSync.find lref_sync_id
    lref_sync.run
    begin
      Stif::CodifLineSynchronization.synchronize
      lref_sync.successful
    rescue Exception => error
      lref_sync.failed error
    end
  end
end
