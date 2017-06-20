class WorkbenchesController < BreadcrumbController
  before_action :query_params, only: [:show]

  defaults resource_class: Workbench
  respond_to :html, only: [:show]

  def show
    scope = resource.all_referentials
    scope = ransack_associated_lines(scope)
    scope = ransack_periode(scope)
    scope = ransack_status(scope)

    # Ignore archived_at_not_null/archived_at_null managed by ransack_status scope
    q_for_result =
      scope.ransack(params[:q].merge(archived_at_not_null: nil, archived_at_null: nil))
    @wbench_refs = sort_result(q_for_result.result).paginate(page: params[:page], per_page: 30)
    @wbench_refs = ModelDecorator.decorate(
      @wbench_refs,
      with: ReferentialDecorator
    )

    @q = scope.ransack(params[:q])
    show! do
      build_breadcrumb :show
    end
  end

  def delete_referentials
    referentials = resource.referentials.where(id: params[:referentials])
    referentials.each do |referential|
      ReferentialDestroyWorker.perform_async(referential.id)
      referential.update_attribute(:ready, false)
    end
    flash[:notice] = t('notice.referentials.deleted')
    redirect_to resource
  end

  private
  def resource
    @workbench = Workbench.find params[:id]
  end

  def sort_result collection
    col = (Workbench.find(params[:id]).referentials.column_names + %w{lines validity_period}).include?(params[:sort]) ? params[:sort] : 'name'
    dir = %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'

    if ['lines', 'validity_period'].include?(col)
      collection.send("order_by_#{col}", dir)
    else
      collection.order("#{col} #{dir}")
    end
  end

  def query_params
    if params[:q].present?
      params[:q].delete_if { |query, value| value.blank? }
    else
      params[:q] = { "archived_at_not_null"=>"1", "archived_at_null"=>"1" }
    end
  end

  # Fake ransack filter
  def ransack_associated_lines scope
    if params[:q] && params[:q]['associated_lines_id_eq']
      scope = scope.include_metadatas_lines([params[:q]['associated_lines_id_eq']])
      params[:q].delete('associated_lines_id_eq')
    end
    scope
  end

  # Fake ransack filter
  def ransack_periode scope
    return scope unless params[:q] && params[:q]['validity_period']
    periode = params[:q]['validity_period']
    return scope if periode['end_lteq(1i)'].blank? || periode['begin_gteq(1i)'].blank?

    begin_range = Date.civil(periode["begin_gteq(1i)"].to_i, periode["begin_gteq(2i)"].to_i, periode["begin_gteq(3i)"].to_i)
    end_range   = Date.civil(periode["end_lteq(1i)"].to_i, periode["end_lteq(2i)"].to_i, periode["end_lteq(3i)"].to_i)

    if begin_range > end_range
      flash.now[:error] = t('referentials.errors.validity_period')
    else
      scope        = scope.in_periode(begin_range..end_range)
      @begin_range = begin_range
      @end_range   = end_range
    end
    scope
  end

  # Fake (again) ransack filter
  def ransack_status scope
    return scope unless params[:q]

    archived_at_not_null = params[:q]['archived_at_not_null'] == '1'
    archived_at_null = params[:q]['archived_at_null'] == '1'

    if !archived_at_not_null and !archived_at_null
      return scope.none
    end

    if archived_at_not_null and archived_at_null
      return scope
    end

    if archived_at_null
      return scope.where(archived_at: nil)
    end

    if archived_at_not_null
      return scope.where("archived_at is not null")
    end

    scope
  end
end
