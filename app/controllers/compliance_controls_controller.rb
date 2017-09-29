class ComplianceControlsController < BreadcrumbController
  defaults resource_class: ComplianceControl
  belongs_to :compliance_control_set

  def select_type
    @sti_subclasses = ComplianceControl.subclasses
  end

  def new
    if params[:sti_class]
      @compliance_control_set = parent
      @compliance_control     = params[:sti_class].constantize.new
    else
      redirect_to(action: :select_type)
    end
  end

  private
  def dynamic_attributes_params
    params.require(:compliance_control).permit(:type).values[0].constantize.dynamic_attributes
  end

  def compliance_control_params
    base = [:name, :code, :origin_code, :criticity, :comment, :control_attributes, :type]
    permited = base + dynamic_attributes_params
    params.require(:compliance_control).permit(permited)
  end
end
