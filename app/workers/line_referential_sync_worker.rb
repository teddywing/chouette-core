class LineReferentialSyncWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def update_started_at lref_sync
    lref_sync.update_attribute(:started_at, Time.now)
  end

  def update_ended_at lref_sync
    lref_sync.update_attribute(:ended_at, Time.now)
  end

  def perform(lref_sync_id)
    lref_sync = LineReferentialSync.find lref_sync_id
    update_started_at lref_sync
    begin
      Stif::CodifLineSynchronization.synchronize
    rescue Exception => e
      ap "LineReferentialSyncWorker perform:rescue #{e.message}"
    ensure
      update_ended_at lref_sync
    end
  end
end
