class ImportsController < BreadcrumbController
  defaults :resource_class => Import
  respond_to :html
  belongs_to :workbench

  # def show
  #   show! do
  #     build_breadcrumb :show
  #   end
  # end

  # def index
  #   index! do
  #     build_breadcrumb :index
  #   end
  # end

  def new
    ap params
    ap @workbench
    ap '------------'
    @import = Import.new
  end
end
