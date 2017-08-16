class ImportsController < BreadcrumbController
  skip_before_action :authenticate_user!, only: [:download]
  defaults resource_class: Import, collection_name: 'imports', instance_name: 'import'
  respond_to :html
  belongs_to :workbench

  def show
    show! do
      build_breadcrumb :show
    end
  end

  def index
    index! do |format|
      format.html {
        if collection.out_of_bounds?
          redirect_to params.merge(:page => 1)
        end

        @imports = decorate_imports(@imports)
      }

      build_breadcrumb :index
    end
  end

  def new
    new! do
      build_breadcrumb :new
    end
  end

  def create
    create! { workbench_import_path(parent, resource) }
  end

  def download
    if params[:token] == resource.token_download
      send_file resource.file.path
    else
      user_not_authorized
    end
  end

  protected
  def collection
    @q = parent.imports.search(params[:q])

    if sort_column && sort_direction
      @imports ||= @q.result(distinct: true).order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 10)
    else
      @imports ||= @q.result(distinct: true).order(:name).paginate(page: params[:page], per_page: 10)
    end
  end

  private

  def build_resource
    # Manage only NetexImports for the moment
    @import ||= NetexImport.new(*resource_params) do |import|
      import.workbench = parent
    end
  end

  def import_params
    params.require(:import).permit(
      :name,
      :file,
      :type,
      :referential_id
    )
  end

  def sort_column
    parent.imports.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

  def decorate_imports(imports)
    ModelDecorator.decorate(
      imports,
      with: ImportDecorator,
      context: {
        workbench: @workbench
      }
    )
  end
end
