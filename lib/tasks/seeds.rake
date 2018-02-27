namespace :db do

  include Seedbank::DSL

  base_dependencies   = ['db:seed:original']
  override_dependency = ['db:seed:common']

  namespace :seed do
    seeds_environment = ENV.fetch("SEED_ENV", Rails.env)
    glob_seed_files_matching('/*/').each do |directory|
      environment = File.basename(directory)
      override_dependency << "db:seed:#{environment}" if defined?(Rails) && seeds_environment == environment
    end
  end

  # Override db:seed to run all the common and environments seeds plus the original db:seed.
  desc 'Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/ENVIRONMENT/*.seeds.rb. ENVIRONMENT is the env var SEED_ENV or the current environment in Rails.env.'
  override_seed_task :seed => override_dependency
end
