class RouteWayCostWorker
  include Sidekiq::Worker

  def perform(referential_id, route_id)
    Referential.find(referential_id).switch
    route = Chouette::Route.find(route_id)

    # Prevent recursive worker spawning since this call updates the
    # `costs` field of the route.
    begin
      Chouette::Route.skip_callback(:commit, :after, :calculate_costs!)
      RouteWayCostCalculator.new(route).calculate!
    ensure
      Chouette::Route.set_callback(:commit, :after, :calculate_costs!)
    end
  end
end
