class BusinessCalendarsController < ChouetteController
  include PolicyChecker
  defaults resource_class: BusinessCalendar
  before_action :ransack_contains_date, only: [:index]
  respond_to :html
  respond_to :js, only: :index

  def index
    index! do
      @business_calendars = ModelDecorator.decorate(@business_calendars, with: BusinessCalendarDecorator)
    end
  end

  def show
    show! do
      @business_calendar = @business_calendar.decorate
    end
  end

  def create
    puts "CREATE"
    puts build_resource.inspect
    create!
  end

  private
  def business_calendar_params
    params.require(:business_calendar).permit(
      :id,
      :name,
      :short_name,
      :color,
      periods_attributes: [:id, :begin, :end, :_destroy],
      date_values_attributes: [:id, :value, :_destroy])
  end

  def sort_column
    BusinessCalendar.column_names.include?(params[:sort]) ? params[:sort] : 'short_name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

  protected

  def begin_of_association_chain
    current_organisation
  end
  #
  # def build_resource
  #   @business_calendar ||= current_organisation.business_calendars.new
  # end
  #
  # def resource
  #   @business_calendar ||= current_organisation.business_calendars.find(params[:id])
  # end

  def collection
    @q = current_organisation.business_calendars.ransack(params[:q])

    business_calendars = @q.result
    business_calendars = business_calendars.order(sort_column + ' ' + sort_direction) if sort_column && sort_direction
    @business_calendars = business_calendars.paginate(page: params[:page])
  end

  def ransack_contains_date
    date =[]
    if params[:q] && !params[:q]['contains_date(1i)'].empty?
      ['contains_date(1i)', 'contains_date(2i)', 'contains_date(3i)'].each do |key|
        date << params[:q][key].to_i
        params[:q].delete(key)
      end
      params[:q]['contains_date'] = Date.new(*date) rescue nil
    end
  end

end
