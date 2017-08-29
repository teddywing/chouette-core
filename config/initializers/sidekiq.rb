Sidekiq.configure_server do |config|
  [
    LineReferentialSync.pending,
    StopAreaReferentialSync.pending
  ].each do |pendings|
    pendings.map { |sync| sync.failed({error: 'Failed by Sidekiq reboot', processing_time: 0}) }
  end
end
