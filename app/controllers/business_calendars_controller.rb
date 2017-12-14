class BusinessCalendarsController < ChouetteController
  include PolicyChecker
  include RansackDateFilter
  defaults resource_class: BusinessCalendar
  before_action only: [:index] { set_date_time_params("bounding_dates", Date) }

  def index
    index! do
      scope = self.ransack_period_range(scope: @business_calendars, error_message: t('compliance_check_sets.filters.error_period_filter'), query: :overlapping)
      @q = scope.ransack(params[:q])
      @business_calendars = decorate_business_calendars(@q.result.paginate(page: params[:page], per_page: 30))
    end
  end

  def show
    show! do
      @business_calendar = @business_calendar.decorate
    end
  end

  private

  def business_calendar_params
    permitted_params = [:id, :name, :short_name, periods_attributes: [:id, :begin, :end, :_destroy], date_values_attributes: [:id, :value, :_destroy]]
    params.require(:business_calendar).permit(*permitted_params)
  end

  def decorate_business_calendars(business_calendars)
    ModelDecorator.decorate(
      business_calendars,
      with: BusinessCalendarDecorator)
  end
end