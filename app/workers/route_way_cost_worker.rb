class RouteWayCostWorker
  include Sidekiq::Worker

  def perform(route_id)
    route = Chouette::Route.find(route_id)
    RouteWayCostCalculator.new(route).calculate!
  end
end
