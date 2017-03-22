class WorkbenchesController < BreadcrumbController
  before_action :query_params, only: [:show]

  defaults resource_class: Workbench
  respond_to :html, only: [:show]

  def show
    scope = params[:q] ? resource.all_referentials : resource.referentials.ready
    scope = ransack_associated_lines(scope)

    @q = ransack_periode(scope).ransack(params[:q])
    @q.organisation_name_eq_any ||= current_organisation.name unless params[:q]
    @wbench_refs = sort_result(@q.result).paginate(page: params[:page], per_page: 30)
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
    col = (Workbench.find(params[:id]).referentials.column_names + %w{lines}).include?(params[:sort]) ? params[:sort] : 'name'
    dir = %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
    if col == "lines"
      collection.joins(:metadatas).group("referentials.id").order("sum(array_length(referential_metadata.line_ids,1)) #{dir}")
    else
      collection.order("#{col} #{dir}")
    end
  end

  def query_params
    if params[:q].present?
      params[:q].delete_if { |query, value| value.blank? }
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
    return scope if periode['end_lteq(1i)'].empty? || periode['begin_gteq(1i)'].empty?

    begin_range = Date.civil(periode["begin_gteq(1i)"].to_i, periode["begin_gteq(2i)"].to_i, periode["begin_gteq(3i)"].to_i)
    end_range   = Date.civil(periode["end_lteq(1i)"].to_i, periode["end_lteq(2i)"].to_i, periode["end_lteq(3i)"].to_i)

    if begin_range > end_range
      flash.now[:error] = t('referentials.errors.validity_period')
    else
      scope = scope.in_periode(begin_range..end_range)
    end
    scope
  end
end
