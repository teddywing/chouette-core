class CalendarsController < BreadcrumbController
  defaults resource_class: Calendar
  before_action :check_policy, only: [:edit, :update, :destroy]

  respond_to :html
  respond_to :js, only: :index

  private
  def calendar_params
    permitted_params = [:id, :name, :short_name, periods_attributes: [:id, :begin, :end, :_destroy], date_values_attributes: [:id, :value, :_destroy]]
    permitted_params << :shared if policy(Calendar).share?
    params.require(:calendar).permit(*permitted_params)
  end

  def sort_column
    Calendar.column_names.include?(params[:sort]) ? params[:sort] : 'short_name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

  protected
  def resource
    @calendar = Calendar.where('organisation_id = ? OR shared = true', current_organisation.id).find_by_id(params[:id])
  end

  def build_resource
    super.tap do |calendar|
      calendar.organisation = current_organisation
    end
  end

  def collection
    return @calendars if @calendars

    @q = Calendar.where('organisation_id = ? OR shared = true', current_organisation.id).search(params[:q])
    calendars = @q.result
    calendars = calendars.order(sort_column + ' ' + sort_direction) if sort_column && sort_direction
    @calendars = calendars.paginate(page: params[:page])
  end

  def check_policy
    authorize resource
  end
end

