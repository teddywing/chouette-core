namespace :codifligne do
  desc "Sync lines, companies, networks, and group of lines from codifligne"
  task sync: :environment  do
    Stif::CodifLineSynchronization.synchronize
  end
end
