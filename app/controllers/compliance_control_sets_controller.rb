class ComplianceControlSetsController < BreadcrumbController
  defaults resource_class: ComplianceControlSet
  before_action :ransack_updated_at_params, only: [:index]
  respond_to :html

  def index
    index! do |format|
      scope = ransack_period @compliance_control_sets
      @q_for_form = scope.ransack(params[:q])
      format.html {
        @compliance_control_sets = decorate_compliance_control_sets(@q_for_form.result)
      }
    end
  end

  def show
    show! do |format|
      format.html {
        @compliance_control_set = @compliance_control_set.decorate
        @compliance_controls_without_block = decorate_compliance_controls(@compliance_control_set.compliance_controls.where(compliance_control_block_id: nil))
      }
    end
  end

  protected

  # def begin_of_association_chain
  #   current_organisation
  # end

  private

  def decorate_compliance_control_sets(compliance_control_sets)
    ModelDecorator.decorate(
      compliance_control_sets,
      with: ComplianceControlSetDecorator
    )
  end

  def decorate_compliance_controls(compliance_controls)
    ModelDecorator.decorate(
      compliance_controls,
      with: ComplianceControlDecorator,
    )
  end

  def ransack_updated_at_params
    start_date = []
    end_date = []

    if params[:q] && params[:q][:updated_at] && !params[:q][:updated_at].has_value?(nil) && !params[:q][:updated_at].has_value?("")
      [1, 2, 3].each do |key|
        start_date <<  params[:q][:updated_at]["begin(#{key}i)"].to_i
        end_date <<  params[:q][:updated_at]["end(#{key}i)"].to_i
      end
      params[:q].delete([:updated_at])
      @begin_range = DateTime.new(*start_date,0,0,0) rescue nil
      @end_range = DateTime.new(*end_date,23,59,59) rescue nil
    end
  end

  # Fake ransack filter
  def ransack_period scope
    return scope unless !!@begin_range && !!@end_range

    if @begin_range > @end_range
      flash.now[:error] = t('imports.filters.error_period_filter')
    else
      scope = scope.where_updated_at_between(@begin_range, @end_range)
    end
    scope
  end

  def compliance_control_set_params
    params.require(:compliance_control_set).permit(:name, :id)
  end
end
