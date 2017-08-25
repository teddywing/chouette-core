class AutocompleteTimeTablesController < InheritedResources::Base
  respond_to :json, :only => [:index]
  before_action :switch_referential

  include ReferentialSupport

  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]
  end

  protected

  def select_time_tables
    scope = referential.time_tables.where("time_tables.id != ?", params[:source_id])
    if params[:route_id]
      scope = scope.joins(vehicle_journeys: :route).where( "routes.id IN (#{params[:route_id]}) AND time_tables.id != #{params[:time_table_id]}")
    end
    scope
  end

  def collection
    @time_tables = select_time_tables.search(params[:q]).result.paginate(page: params[:page])
  end
end
