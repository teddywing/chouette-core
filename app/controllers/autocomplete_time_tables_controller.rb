class AutocompleteTimeTablesController < InheritedResources::Base
  respond_to :json, :only => [:index]
  before_action :switch_referential

  include ReferentialSupport

  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end

  def referential
    @referential ||= Referential.find params[:referential_id]
  end

  protected

  def select_time_tables
    scope = params[:source_id] ? referential.time_tables.where("time_tables.id != ?", params[:source_id]) : referential.time_tables
    if params[:route_id]
      scope = scope.joins(vehicle_journeys: :route).where( "routes.id IN (#{params[:route_id]})")
    end
    scope.distinct
  end

  def collection
    @time_tables = select_time_tables.search(params[:q]).result.paginate(page: params[:page])
  end
end
