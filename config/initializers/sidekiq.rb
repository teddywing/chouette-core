Sidekiq.configure_server do |config|
  pendings = [
    LineReferential.find_by(name: 'CodifLigne').line_referential_syncs.pending.take,
    StopAreaReferential.find_by(name: 'Reflex').stop_area_referential_syncs.pending.take
  ]
  pendings.compact.map{|sync| sync.failed({error: 'Failed by Sidekiq reboot', processing_time: 0})}
end
