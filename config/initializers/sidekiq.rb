Sidekiq.configure_server do |config|
  if ENV["CHOUETTE_SIDEKIQ_CANCEL_SYNCS_ON_BOOT"]
    [
      LineReferentialSync.pending,
      StopAreaReferentialSync.pending
    ].each do |pendings|
      pendings.map { |sync| sync.failed({error: 'Failed by Sidekiq reboot', processing_time: 0}) }
    end
  end
end
