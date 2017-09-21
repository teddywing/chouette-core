class ComplianceControlsController < BreadcrumbController
  include PolicyChecker
  defaults resource_class: ComplianceControl
  belongs_to :compliance_control_set

  def create
    create!(notice: t('notice.compliance_control.created'))
  end

  def update
    path = compliance_control_set_compliance_control_path(parent, resource)
    update!(notice: t('notice.compliance_control.updated')) { path }
  end

  def destroy
    destroy!(notice: t('notice.compliance_control.destroyed'))
  end

  private
  def compliance_control_params
    params.require(:compliance_control).permit(:name, :code, :criticity, :comment, :control_attributes, :type)
  end
end
