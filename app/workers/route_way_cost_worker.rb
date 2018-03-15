class RouteWayCostWorker
  include Sidekiq::Worker

  def perform(referential_id, route_id)
    Referential.find(referential_id).switch
    route = Chouette::Route.find(route_id)

    # Prevent recursive worker spawning since this call updates the
    # `costs` field of the route.
    Chouette::Route.skip_callback(:save, :after, :calculate_costs!)

    RouteWayCostCalculator.new(route).calculate!

    Chouette::Route.set_callback(:save, :after, :calculate_costs!)
  end
end
