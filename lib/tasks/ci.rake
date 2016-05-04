namespace :ci do
  desc "Prepare CI build"
  task :setup do
    cp "config/database/jenkins.yml", "config/database.yml"
    sh "RAILS_ENV=test rake db:migrate"
  end

  def git_branch
    if ENV['GIT_BRANCH'] =~ %r{/(.*)$}
      $1
    else
      `git rev-parse --abbrev-ref HEAD`.strip
    end
  end

  def deploy_envs
    Dir["config/deploy/*.rb"].map { |f| File.basename(f, ".rb") }
  end

  def deploy_env
    git_branch.in?(deploy_envs) ? git_branch : "dev"
  end

  desc "Deploy after CI"
  task :deploy do
    sh "cap #{deploy_env} deploy:migrations deploy:seed"
  end

  desc "Clean test files"
  task :clean do
    sh "rm -rf log/test.log"
  end
end

desc "Run continuous integration tasks (spec, ...)"
task :ci => ["ci:setup", "spec", "ci:deploy", "ci:clean"]
