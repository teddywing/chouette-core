class WorkbenchesController < BreadcrumbController
  defaults :resource_class => Workbench
  respond_to :html, :only => [:show]

  def show
    scope   = Workbench.find(params[:id])
    scope   = params[:q] ? scope.all_referentials : scope.referentials.ready
    periode = ransack_periode
    scope   = scope.in_periode(periode) if periode
    @q      = scope.ransack(params[:q])

    @q.organisation_name_eq_any ||= current_organisation.name unless params[:q]
    @wbench_refs  = @q.result
    # @wbench_refs = Workbench.find(params[:id]).referentials

    case sort_column
    when "lines"
      @wbench_refs = @wbench_refs.joins(:metadatas).group("referentials.id").order("sum(array_length(referential_metadata.line_ids,1)) #{sort_direction}")
    else
      @wbench_refs = @wbench_refs.order("#{sort_column} #{sort_direction}")
    end

    @wbench_refs = @wbench_refs.paginate(page: params[:page], per_page: 30)

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
  def sort_column
    (Workbench.find(params[:id]).referentials.column_names + %w{lines}).include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

  def ransack_periode
    return false unless params[:q] && params[:q]['validity_period']
    periode = params[:q]['validity_period']
    return false if periode['end_lteq(1i)'].empty? || periode['begin_gteq(1i)'].empty?

    start_range = Date.civil(periode["begin_gteq(1i)"].to_i, periode["begin_gteq(2i)"].to_i, periode["begin_gteq(3i)"].to_i)
    end_range   = Date.civil(periode["end_lteq(1i)"].to_i, periode["end_lteq(2i)"].to_i, periode["end_lteq(3i)"].to_i)

    if start_range > end_range
      flash.now[:error] = t('referentials.errors.validity_period')
      false
    else
      start_range..end_range
    end
  end
end
