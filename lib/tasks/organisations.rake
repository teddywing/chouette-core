namespace :organisations do
  desc "Sync organisations from stif portail"
  task sync: :environment  do
    Organisation.portail_sync
  end
end
