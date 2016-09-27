namespace :codifligne do
  desc "Sync lines, companies, networks, and group of lines from codifligne"
  task sync: :environment  do
    lref      = LineReferential.find_by(name: 'CodifLigne')
    lref_sync = LineReferentialSync.create(line_referential: lref)
    raise "Codifligne:sync aborted - an sync is already running" unless lref_sync.valid?
    lref_sync.save if lref_sync.valid?
  end
end
