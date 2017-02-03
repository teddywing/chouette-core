class WorkbenchesController < BreadcrumbController

  defaults :resource_class => Workbench
  respond_to :html, :only => [:show]

  def show
    @wbench_refs = if params[:show_all]
      Workbench.find(params[:id]).all_referentials.order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 30)
    else
      Workbench.find(params[:id]).referentials.ready.order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 30)
      # Workbench.find(params[:id]).referentials.order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 30)
    end

    show! do
      build_breadcrumb :show
    end
  end

  private
  def sort_column
    Workbench.find(params[:id]).referentials.include?(params[:sort]) ? params[:sort] : 'name'
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

end
