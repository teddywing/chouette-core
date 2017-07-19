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
      @time_table = @time_table.decorate(context: {
        referential: @referential
      })
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
      calendar = Calendar.find(tt_params[:calendar_id])
      tt_params[:calendar_id] = nil if tt_params.has_key?(:dates_attributes) || tt_params.has_key?(:periods_attributes)
    end

    created_from = duplicate_source
    @time_table  = created_from ? created_from.duplicate : Chouette::TimeTable.new(tt_params)

    if calendar
      calendar.dates.each_with_index do |date, i|
        @time_table.dates << Chouette::TimeTableDate.new(date: date, position: i, in_out: true)
      end
      calendar.periods.each_with_index do |period, i|
        @time_table.periods << Chouette::TimeTablePeriod.new(period_start: period.begin, period_end: period.end, position: i)
      end
    end

    create! do |success, failure|
      success.html do
        path = @time_table.created_from ? 'referential_time_table_path' : 'edit_referential_time_table_path'
        redirect_to send(path, @referential, @time_table)
      end
      failure.html { render :new }
    end
  end

  def edit
    edit! do
      build_breadcrumb :edit
      @autocomplete_items = ActsAsTaggableOn::Tag.all
    end
  end

  def update
    state  = JSON.parse request.raw_post
    resource.state_update state
    respond_to do |format|
      format.json { render json: state, status: state['errors'] ? :unprocessable_entity : :ok }
    end
  end

  def index
    request.format.kml? ? @per_page = nil : @per_page = 12

    index! do |format|
      format.html {
        if collection.out_of_bounds?
          redirect_to params.merge(:page => 1)
        end

        @time_tables = ModelDecorator.decorate(
          @time_tables,
          with: TimeTableDecorator,
          context: {
            referential: @referential
          }
        )

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

  def actualize
    @time_table = resource
    if @time_table.calendar
      @time_table.actualize
      flash[:notice] = t('.success')
    end
    redirect_to referential_time_table_path @referential, @time_table
  end

  def tags
    @tags = ActsAsTaggableOn::Tag.where("tags.name = ?", "%#{params[:tag]}%")
    respond_to do |format|
      format.json { render :json => @tags.map{|t| {:id => t.id, :name => t.name }} }
    end
  end

  protected

  def collection
    scope = select_time_tables
    if params[:q] && params[:q]["tag_search"]
      tags = params[:q]["tag_search"].reject {|c| c.empty?}
      params[:q].delete("tag_search")
      scope = select_time_tables.tagged_with(tags, :any => true) if tags.any?
    end
    scope = ransack_periode(scope)
    @q = scope.search(params[:q])

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
  def ransack_periode scope
    return scope unless params[:q]
    return scope unless params[:q]['end_date_lteq(1i)'].present?

    begin_range = flatten_date('start_date_gteq')
    end_range   = flatten_date('end_date_lteq')

    if begin_range > end_range
      flash.now[:error] = t('referentials.errors.validity_period')
    else
      scope        = scope.overlapping(begin_range, end_range)
      params[:q]   = params[:q].slice('comment_cont', 'color_cont_any')
      @begin_range = begin_range
      @end_range   = end_range
    end
    scope
  end

  def flatten_date key
    date_int = %w(1 2 3).map {|e| params[:q]["#{key}(#{e}i)"].to_i }
    Date.new(*date_int)
  end

  def sort_column
    referential.time_tables.column_names.include?(params[:sort]) ? params[:sort] : 'comment'
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

  def duplicate_source
    from_id = time_table_params['created_from_id']
    Chouette::TimeTable.find(from_id) if from_id
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
      :created_from_id,
      { :dates_attributes => [:date, :in_out, :id, :_destroy] },
      { :periods_attributes => [:period_start, :period_end, :_destroy, :id] },
      {tag_list: []},
      :tag_search
    )
  end
end
