class AutocompleteTimeTablesController < InheritedResources::Base
  respond_to :json, :only => [:index]
  before_action :switch_referential

  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]
  end

  protected

  def select_time_tables
    scope = referential.time_tables
    if params[:route_id]
      scope = scope.joins(vehicle_journeys: :route).where( "routes.id IN (#{params[:route_id]})")
    end
    scope
  end

  def collection
    @time_tables = select_time_tables.search(params[:q]).result.paginate(page: params[:page])
  end
end
