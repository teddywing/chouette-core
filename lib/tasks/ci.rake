namespace :ci do
  desc "Prepare CI build"
  task :setup do
    cp "config/database/jenkins.yml", "config/database.yml"
    sh "RAILS_ENV=test rake db:migrate"
  end

  desc "Deploy after CI"
  task :deploy do
    sh "cap dev deploy"
  end

  desc "Clean test files"
  task :clean do
    sh "rm -rf log/test.log"
  end
end

desc "Run continuous integration tasks (spec, ...)"
task :ci => ["ci:setup", "spec", "ci:deploy", "ci:clean"]
