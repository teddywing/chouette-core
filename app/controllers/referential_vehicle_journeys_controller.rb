#
# Browse all VehicleJourneys of the Referential
#
class ReferentialVehicleJourneysController < ChouetteController
  include ReferentialSupport
  defaults :resource_class => Chouette::VehicleJourney, collection_name: :vehicle_journeys

  requires_feature :referential_vehicle_journeys

  private

  def collection
    @q ||= end_of_association_chain.ransack(params[:q])
    @vehicle_journeys ||= @q.result.order(:published_journey_name).includes(:vehicle_journey_at_stops).paginate page: params[:page], per_page: 10
    @all_companies = Chouette::Company.where("id IN (#{@referential.vehicle_journeys.select(:company_id).to_sql})").distinct
  end

end
