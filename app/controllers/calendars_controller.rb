class CalendarsController < BreadcrumbController
  include PolicyChecker
  defaults resource_class: Calendar
  before_action :ransack_contains_date, only: [:index]
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
    scope = Calendar.where('organisation_id = ? OR shared = ?', current_organisation.id, true)
    scope = shared_scope(scope)
    @q = scope.ransack(params[:q])

    calendars = @q.result
    calendars = calendars.order(sort_column + ' ' + sort_direction) if sort_column && sort_direction
    @calendars = calendars.paginate(page: params[:page])
  end

  def ransack_contains_date
    date =[]
    if params[:q] && !params[:q]['contains_date(1i)'].empty?
      ['contains_date(1i)', 'contains_date(2i)', 'contains_date(3i)'].each do |key|
        date << params[:q][key].to_i
        params[:q].delete(key)
      end
      params[:q]['contains_date'] = Date.new(*date)
    end
  end

  def shared_scope scope
    return scope unless params[:q]

    if params[:q][:shared_true] == params[:q][:shared_false]
      params[:q].delete(:shared_true)
      params[:q].delete(:shared_false)
    end

    scope
  end

end
