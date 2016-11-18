class WorkbenchesController < BreadcrumbController

  defaults :resource_class => Workbench
  respond_to :html, :only => [:show]

  def show
    @wbench_refs = Workbench.find(params[:id]).referentials.paginate(page: params[:page], per_page: 2)

    show! do
      build_breadcrumb :show
    end
  end

end
