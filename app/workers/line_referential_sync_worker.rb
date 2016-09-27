class LineReferentialSyncWorker
  include Sidekiq::Worker

  def update_started_at lref_sync
    lref_sync.update_attribute(:started_at, Time.now)
  end

  def update_ended_at lref_sync
    lref_sync.update_attribute(:ended_at, Time.now)
  end

  def perform(lref_sync_id)
    logger.info "worker call to perfom"
    lref_sync = LineReferentialSync.find lref_sync_id
    update_started_at lref_sync
    begin
      Stif::CodifLineSynchronization.synchronize
      logger.info "worker done CodifLineSynchronization"
    rescue Exception => e
      ap "LineReferentialSyncWorker perform:rescue #{e.message}"
    ensure
      logger.info "worker ensure ended_at"
      update_ended_at lref_sync
    end
  end
end
