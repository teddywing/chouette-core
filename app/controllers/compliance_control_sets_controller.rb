class ComplianceControlSetsController < BreadcrumbController
  defaults resource_class: ComplianceControlSet
  respond_to :html

  def index
    index! do |format|
      format.html {
        @compliance_control_sets = decorate_compliance_control_sets(@compliance_control_sets)
      }
    end
  end

  def show
    show! do
      @compliance_control_set = @compliance_control_set.decorate
    end
  end

  def decorate_compliance_control_sets(compliance_control_sets)
    ModelDecorator.decorate(
      compliance_control_sets,
      with: ComplianceControlSetDecorator
    )
  end

  protected

  private

  def compliance_control_set_params
    params.require(:compliance_control_set).permit(:name)
  end
end
