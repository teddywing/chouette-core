class ReferentialCloningWorker
  include Sidekiq::Worker

  def perform(id)
    if operation = ReferentialCloning.find(id)
      operation.clone!
    end
  end
end
