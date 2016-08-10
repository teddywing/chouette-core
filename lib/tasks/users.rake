namespace :users do
  desc "Sync users from stif portail"
  task sync: :environment  do
    User.portail_sync
  end
end
