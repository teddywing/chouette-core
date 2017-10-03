class ComplianceControlSetsController < BreadcrumbController
  defaults resource_class: ComplianceControlSet
  include RansackDateFilter
  set_date_param "updated_at", DateTime
  before_action :set_date_time_params, only: [:index]
  respond_to :html

  def index
    index! do |format|
      scope = ransack_period_range(scope: @compliance_control_sets, error_message: t('imports.filters.error_period_filter'), query: :where_updated_at_between)
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

  def begin_of_association_chain
    current_organisation
  end

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

  def compliance_control_set_params
    params.require(:compliance_control_set).permit(:name, :id)
  end
end
