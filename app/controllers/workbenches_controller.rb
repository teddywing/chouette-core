class WorkbenchesController < BreadcrumbController
  defaults :resource_class => Workbench
  respond_to :html, :only => [:show]

  def show
    scope = Workbench.find(params[:id])
    scope = params[:q] ? scope.all_referentials : scope.referentials.ready
    scope = scope.in_periode(ransack_periode) if ransack_periode
    @q = scope.ransack(params[:q])
    @q.organisation_name_eq_any ||= current_organisation.name unless params[:q]

    @collection = @q.result(distinct: true)
    @wbench_refs = @collection.order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 30)
    show! do
      build_breadcrumb :show
    end
  end

  def delete_referentials
    referentials = resource.referentials.where(id: params[:referentials])
    if referentials.destroy_all
      flash[:notice] = t('notice.referentials.deleted')
    end
    redirect_to resource
  end

  private
  def sort_column
    Workbench.find(params[:id]).referentials.include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

  def ransack_periode
    return unless params[:q] && params[:q]['validity_period']

    periode     = params[:q]['validity_period']
    start_range = Date.civil(periode["begin_gteq(1i)"].to_i, periode["begin_gteq(2i)"].to_i, periode["begin_gteq(3i)"].to_i)
    end_range   = Date.civil(periode["end_lteq(1i)"].to_i, periode["end_lteq(2i)"].to_i, periode["end_lteq(3i)"].to_i)
    start_range..end_range
  end
end
