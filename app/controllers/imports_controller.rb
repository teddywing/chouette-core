class ImportsController < BreadcrumbController
  defaults :resource_class => Import
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

  private

  def import_params
    params.require(:import).permit(:name, :file, :referential_id)
  end
end
