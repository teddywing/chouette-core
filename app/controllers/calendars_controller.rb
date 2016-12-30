class CalendarsController < BreadcrumbController
  defaults resource_class: Calendar
  before_action :check_policy, only: [:edit, :update, :destroy]

  private
  def calendar_params
    params.require(:calendar).permit(:id, :name, :short_name, :shared, ranges_attributes: [:id, :begin, :end, :_destroy], dates: [])
  end

  def sort_column
    Calendar.column_names.include?(params[:sort]) ? params[:sort] : 'short_name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

  protected
  def resource
    @calendar = current_organisation.calendars.find_by_id(params[:id])
  end

  def build_resource
    super.tap do |calendar|
      calendar.organisation = current_organisation
    end
  end

  def collection
    return @calendars if @calendars
    if params[:q]
      params[:q].delete(:shared_eq) if params[:q][:shared_eq] == ''
      params[:q].delete(:short_name_cont) if params[:q][:short_name_cont] == ''
    end

    @q = current_organisation.calendars.search(params[:q])
    calendars = @q.result(distinct: true)
    calendars = calendars.order(sort_column + ' ' + sort_direction) if sort_column && sort_direction
    @calendars = calendars.paginate(page: params[:page])
  end

  def check_policy
    authorize resource
  end
end

