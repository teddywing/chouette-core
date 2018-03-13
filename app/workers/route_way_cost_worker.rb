class RouteWayCostWorker
  include Sidekiq::Worker

  def perform(referential_id, route_id)
    Referential.find(referential_id).switch
    route = Chouette::Route.find(route_id)
    RouteWayCostCalculator.new(route).calculate!
  end
end
