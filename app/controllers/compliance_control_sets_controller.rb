class ComplianceControlSetsController < BreadcrumbController
  defaults resource_class: ComplianceControlSet
  respond_to :html

  def index
    index! do |format|
      @q_for_form = @compliance_control_sets.ransack(params[:q])
      format.html {
        @compliance_control_sets = decorate_compliance_control_sets(@q_for_form.result)
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

  def begin_of_association_chain
    current_organisation
  end

  private

  def compliance_control_set_params
    params.require(:compliance_control_set).permit(:name, :id)
  end
end
