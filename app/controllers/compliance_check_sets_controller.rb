class ComplianceCheckSetsController < BreadcrumbController
  defaults resource_class: ComplianceCheckSet
  before_action :ransack_created_at_params, only: [:index]
  respond_to :html

  belongs_to :workbench

  def index
    index! do |format|
      scope = ransack_period @compliance_check_sets
      @q_for_form = scope.ransack(params[:q])
      format.html {
        @compliance_check_sets = decorate_compliance_check_sets(@q_for_form.result)
      }
    end
  end

  def decorate_compliance_check_sets(compliance_check_sets)
    ModelDecorator.decorate(
      compliance_check_sets,
      with: ComplianceCheckSetDecorator
    )
  end

  private

  def ransack_created_at_params
    start_date = []
    end_date = []

    if params[:q] && params[:q][:created_at] && !params[:q][:created_at].has_value?(nil) && !params[:q][:created_at].has_value?("")
      [1, 2, 3].each do |key|
        start_date << params[:q][:created_at]["begin(#{key}i)"].to_i
        end_date << params[:q][:created_at]["end(#{key}i)"].to_i
      end
      params[:q].delete([:created_at])
      @begin_range = DateTime.new(*start_date, 0, 0, 0) rescue nil
      @end_range = DateTime.new(*end_date, 23, 59, 59) rescue nil
    end
  end

  # Fake ransack filter
  def ransack_period scope
    return scope unless !!@begin_range && !!@end_range

    if @begin_range > @end_range
      flash.now[:error] = t('imports.filters.error_period_filter')
    else
      scope = scope.where_created_at_between(@begin_range, @end_range)
    end
    scope
  end

end