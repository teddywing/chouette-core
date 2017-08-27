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
    index! do
      build_breadcrumb :index
    end
  end

  def new
    new! do
      build_breadcrumb :new
    end
  end

  def download
    if params[:token] == resource.token_download
      send_file resource.file.path
    else
      user_not_authorized
    end
  end

  private

  def build_resource
    @import ||= WorkbenchImport.new(*resource_params) do |import|
      import.workbench = parent
    end
  end

  def collection
    @imports ||= WorkbenchImport.all
  end

  def import_params
    params.require(:import).permit(:name, :file, :type, :referential_id)
  end
end
