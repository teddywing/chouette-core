class TimeTablesController < ChouetteController
  include TimeTablesHelper
  defaults :resource_class => Chouette::TimeTable
  respond_to :html
  respond_to :xml
  respond_to :json
  respond_to :js, :only => :index

  belongs_to :referential

  include PolicyChecker

  def show
    @year = params[:year] ? params[:year].to_i : Date.today.cwyear
    @time_table_combination = TimeTableCombination.new
    show! do
      build_breadcrumb :show
    end
  end

  def month
    @date = params['date'] ? Date.parse(params['date']) : Date.today
    @time_table = resource
  end

  def new
    @autocomplete_items = ActsAsTaggableOn::Tag.all
    new! do
      build_breadcrumb :new
    end
  end

  def create
    tt_params = time_table_params
    if tt_params[:calendar_id]
      %i(monday tuesday wednesday thursday friday saturday sunday).map { |d| tt_params[d] = true }
      calendar = current_organisation.calendars.find_by_id(tt_params[:calendar_id])
      tt_params[:calendar_id] = nil if tt_params.has_key?(:dates_attributes) || tt_params.has_key?(:periods_attributes)
    end
    @time_table = Chouette::TimeTable.new(tt_params)
    if calendar
      calendar.dates.each_with_index do |date, i|
        @time_table.dates << Chouette::TimeTableDate.new(date: date, position: i)
      end
      calendar.date_ranges.each_with_index do |date_range, i|
        @time_table.periods << Chouette::TimeTablePeriod.new(period_start: date_range.begin, period_end: date_range.end, position: i)
      end
    end
    create!
  end

  def edit
    edit! do
      build_breadcrumb :edit
      @autocomplete_items = ActsAsTaggableOn::Tag.all
    end
  end

  def update
    @time_table = Chouette::TimeTable.find_by_id(params[:id])
    @time_table.calendar_id = nil
    update!
  end

  def index
    request.format.kml? ? @per_page = nil : @per_page = 12

    index! do |format|
      format.html {
        if collection.out_of_bounds?
          redirect_to params.merge(:page => 1)
        end
        build_breadcrumb :index
      }
    end
  end

  def duplicate
    @time_table = Chouette::TimeTable.find params[:id]
    # prepare breadcrumb before prepare data for new timetable
    build_breadcrumb :edit
    @time_table = @time_table.duplicate
    render :new
  end

  def tags
    @tags = ActsAsTaggableOn::Tag.where("tags.name LIKE ?", "%#{params[:tag]}%")
    respond_to do |format|
      format.json { render :json => @tags.map{|t| {:id => t.id, :name => t.name }} }
    end
  end

  protected

  def collection
    ransack_params = params[:q]
    # Hack to delete params can't be used by ransack
    tag_search = ransack_params["tag_search"].split(",").collect(&:strip) if ransack_params.present? && ransack_params["tag_search"].present?
    ransack_params.delete("tag_search") if ransack_params.present?

    selected_time_tables = tag_search ? select_time_tables.tagged_with(tag_search, :wild => true, :any => true) : select_time_tables

    @q = selected_time_tables.search(ransack_params)

    if sort_column && sort_direction
      @time_tables ||= @q.result(:distinct => true).order("#{sort_column} #{sort_direction}")
    else
      @time_tables ||= @q.result(:distinct => true).order(:comment)
    end
    @time_tables = @time_tables.paginate(page: params[:page], per_page: 10)
  end

  def select_time_tables
    if params[:route_id]
      referential.time_tables.joins(vehicle_journeys: :route).where( "routes.id IN (#{params[:route_id]})")
   else
      referential.time_tables
   end
  end

  def resource_url(time_table = nil)
    referential_time_table_path(referential, time_table || resource)
  end

  def collection_url
    referential_time_tables_path(referential)
  end

  private
  def sort_column
    referential.time_tables.column_names.include?(params[:sort]) ? params[:sort] : 'comment'
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

  def time_table_params
    params.require(:time_table).permit(
      :objectid,
      :object_version,
      :creator_id,
      :calendar_id,
      :version, :comment, :color,
      :int_day_types,
      :monday,
      :tuesday,
      :wednesday,
      :thursday,
      :friday,
      :saturday,
      :sunday,
      :start_date,
      :end_date,
      { :dates_attributes => [:date, :in_out, :id, :_destroy] },
      { :periods_attributes => [:period_start, :period_end, :_destroy, :id] },
      {tag_list: []},
      :tag_search
    )
  end
end
