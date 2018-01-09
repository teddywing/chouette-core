server "stif-boiv-worker-staging.af83.priv", :app, :web, :db, :primary => true, :user => 'deploy'
set :branch, 'staging'
