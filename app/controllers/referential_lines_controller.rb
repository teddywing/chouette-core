class ReferentialLinesController < ChouetteController
  before_action :check_policy, :only => [:edit, :update, :destroy]

  defaults :resource_class => Chouette::Line, :collection_name => 'lines', :instance_name => 'line'
  respond_to :html
  respond_to :xml
  respond_to :json
  respond_to :kml, :only => :show
  respond_to :js, :only => :index

  belongs_to :referential

  def index
    @hide_group_of_line = referential.group_of_lines.empty?
    index! do |format|
      format.html {
        if collection.out_of_bounds?
          redirect_to params.merge(:page => 1)
        end
        build_breadcrumb :index
      }
    end
  end

  def show
    @map = LineMap.new(resource).with_helpers(self)
    @routes = @line.routes.order(:name)
    @group_of_lines = @line.group_of_lines
    show! do
      build_breadcrumb :show
    end
  end

  # overwrite inherited resources to use delete instead of destroy
  # foreign keys will propagate deletion)
  def destroy_resource(object)
    object.delete
  end

  def delete_all
    objects =
      get_collection_ivar || set_collection_ivar(end_of_association_chain.where(:id => params[:ids]))
    objects.each { |object| object.delete }
    respond_with(objects, :location => smart_collection_url)
  end

  def name_filter
    respond_to do |format|
      format.json { render :json => filtered_lines_maps}
    end
  end

  protected

  def build_resource
    super.tap do |resource|
      resource.line_referential = referential.line_referential
    end
  end

  def filtered_lines_maps
    filtered_lines.collect do |line|
      { :id => line.id, :name => (line.published_name ? line.published_name : line.name) }
    end
  end

  def filtered_lines
    referential.lines.by_text(params[:q])
  end

  def collection
    %w(network_id company_id group_of_lines_id comment_id transport_mode).each do |filter|
      if params[:q] && params[:q]["#{filter}_eq"] == '-1'
        params[:q]["#{filter}_eq"] = ''
        params[:q]["#{filter}_blank"] = '1'
      end
    end

    @q = referential.lines.search(params[:q])

    if sort_column && sort_direction
      @lines ||= @q.result(:distinct => true).order(sort_column + ' ' + sort_direction).paginate(:page => params[:page]).includes([:network, :company])
    else
      @lines ||= @q.result(:distinct => true).order(:number).paginate(:page => params[:page]).includes([:network, :company])
    end

  end

  private

  def sort_column
    # params[:sort] || 'number'
    referential.lines.column_names.include?(params[:sort]) ? params[:sort] : 'number'
  end
  def sort_direction
    # params[:direction] || 'asc'
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

  def check_policy
    authorize resource
  end

  def line_params
    params.require(:line).permit(
      :transport_mode,
      :transport_submode,
      :network_id,
      :company_id,
      :objectid,
      :object_version,
      :creation_time,
      :creator_id,
      :name, :number,
      :published_name,
      :transport_mode,
      :registration_number,
      :comment,
      :mobility_restricted_suitability,
      :int_user_needs,
      :flexible_service,
      :group_of_lines,
      :group_of_line_ids,
      :group_of_line_tokens,
      :url,
      :color,
      :text_color,
      :stable_id
      )
  end

end
