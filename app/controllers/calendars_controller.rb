class CalendarsController < BreadcrumbController
  defaults resource_class: Calendar
  before_action :check_policy, only: [:edit, :update, :destroy]

  def new
    new! do
      @calendar.date_ranges = []
      @calendar.dates = []
    end
  end

  def create
    @calendar = current_organisation.calendars.build(calendar_params)

    if @calendar.valid?
      respond_with @calendar
    else
      render action: 'new'
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to calendar_path(@calendar) }
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { redirect_to calendars_path }
    end
  end

  private
  def calendar_params
    params.require(:calendar).permit(:id, :name, :short_name, :shared, ranges_attributes: [:id, :begin, :end, :_destroy], dates: [])
  end

  def sort_column
    current_organisation.calendars.column_names.include?(params[:sort]) ? params[:sort] : 'short_name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

  protected
  def collection
    # if params[:q]
    #   if params[:q][:shared_eq]
    #     if params[:q][:shared_eq] == 'all'
    #       params[:q].delete(:shared_eq)
    #     else
    #       params[:q][:shared_eq] = params[:q][:shared_eq] == 'true'
    #     end
    #   end
    # end

    @q = current_organisation.calendars.search(params[:q])

    if sort_column && sort_direction
      @calendars ||= @q.result(distinct: true).order(sort_column + ' ' + sort_direction).paginate(page: params[:page])
    else
      @calendars ||= @q.result(distinct: true).paginate(page: params[:page])
    end
  end

  def check_policy
    authorize resource
  end
end

