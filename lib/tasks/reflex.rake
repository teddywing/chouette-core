namespace :reflex do
  desc "Sync data from Reflex api"
  task sync: :environment  do
    start = Time.now
    Stif::ReflexSynchronization.synchronize_stop_area
    Rails.logger.debug "Reflex-api sync done in #{Time.now - start} seconds !"
  end
end
