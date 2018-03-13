class RouteWayCostWorker
  include Sidekiq::Worker

  def perform(referential_id, route_id)
    Referential.find(referential_id).switch
    route = Chouette::Route.find(route_id)

    Chouette::Route.skip_callback(:save, :after, :calculate_costs!)

    RouteWayCostCalculator.new(route).calculate!

    Chouette::Route.set_callback(:save, :after, :calculate_costs!)
  end
end
