class ReferentialCloningWorker
  include Sidekiq::Worker

  def perform(id)
    ReferentialCloning.find(id).clone_with_status!
  end
end
