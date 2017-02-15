class WorkbenchesController < BreadcrumbController
  defaults :resource_class => Workbench
  respond_to :html, :only => [:show]

  def show
    scope = Workbench.find(params[:id])
    if params[:q] and params[:q][:organisation_name_eq_any] and params[:q][:organisation_name_eq_any].include? current_organisation.name
      scope = scope.referentials.ready
    else
      scope = scope.all_referentials
    end

    @q = scope.ransack(params[:q])

    @collection = @q.result(distinct: true)
    @wbench_refs = @collection.order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 30)

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
