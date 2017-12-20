#
# Browse all VehicleJourneys of the Referential
#
class ReferentialVehicleJourneysController < ChouetteController
  include ReferentialSupport
  defaults :resource_class => Chouette::VehicleJourney, collection_name: :vehicle_journeys

  private

  def collection
    @q ||= end_of_association_chain.ransack(params[:q])
    @vehicle_journeys ||= @q.result.includes(:vehicle_journey_at_stops).paginate page: params[:page], per_page: 10
  end

end
