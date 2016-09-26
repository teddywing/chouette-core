class LineReferentialSyncWorker
  include Sidekiq::Worker

  def update_started_at lref_sync
    lref_sync.update_attribute(:started_at, Time.now)

  end

  def perform(lref_sync_id)
    lref_sync = LineReferentialSync.find lref_sync_id

    begin
      Stif::CodifLineSynchronization.synchronize
      lref_sync.update_attribute(:ended_at, Time.now)
    rescue Exception => e
      ap 'call to rescue Exception'
    end
  end
end
