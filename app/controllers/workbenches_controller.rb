class WorkbenchesController < BreadcrumbController

  defaults :resource_class => Workbench
  respond_to :html, :only => [:show]

  def show
    @wbench_refs = if params[:show_all]
      Workbench.find(params[:id]).all_referentials.paginate(page: params[:page], per_page: 20)
    else
      Workbench.find(params[:id]).referentials.ready.paginate(page: params[:page], per_page: 20)
    end

    show! do
      build_breadcrumb :show
    end
  end

end
