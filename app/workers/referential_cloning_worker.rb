class ReferentialCloningWorker
  include Sidekiq::Worker

  def perform(id)
    ReferentialCloning.find(id).clone!
  end
end
