class ComplianceControlsController < BreadcrumbController
  defaults resource_class: ComplianceControl
  belongs_to :compliance_control_set

  def new
    @compliance_control_set = parent
    @compliance_control = GenericAttributeMinMax.new
    @compliance_control.build_compliance_control_block
  end

  def update
    path = compliance_control_set_compliance_control_path(parent, resource)
    update!(notice: t('notice.compliance_control.updated')) { path }
  end

  private
  def dynamic_attributes_params
    params.require(:compliance_control).permit(:type).values[0].constantize.dynamic_attributes
  end

  def compliance_control_params
    base = [:name, :code, :origin_code, :criticity, :comment, :control_attributes, :type, compliance_control_block_attributes: [:name, :transport_mode]]
    permited = base + dynamic_attributes_params
    params.require(:compliance_control).permit(permited)
  end
end
