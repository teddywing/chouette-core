namespace :codifligne do
  desc "Sync lines, companies, networks, and group of lines from codifligne"
  task sync: :environment  do
    lref = LineReferential.find_by(name: 'CodifLigne')
    sync = lref.line_referential_syncs.build
    raise "Codifligne:sync aborted - There is already an synchronisation in progress" unless sync.valid?
    sync.save if sync.valid?
  end
end
