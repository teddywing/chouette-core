class ReferentialDestroyWorker
  include Sidekiq::Worker

  def perform(id)
    ref = Referential.find id
    ref.destroy if ref
  end
end
