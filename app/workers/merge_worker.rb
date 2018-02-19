class MergeWorker
  include Sidekiq::Worker

  def perform(id)
    Merge.find(id).merge!
  end
end
