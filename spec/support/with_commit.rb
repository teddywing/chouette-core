module WithCommit
  def with_commit
    yield
    subject._run_commit_callbacks
  end
end

RSpec.configure do |conf|
  conf.include WithCommit, type: :with_commit
end
