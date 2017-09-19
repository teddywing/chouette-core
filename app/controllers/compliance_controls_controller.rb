class ComplianceControlsController < BreadcrumbController
  include PolicyChecker
  defaults resource_class: ComplianceControl
  belongs_to :compliance_control_set

  def index
    index! do |format|
      format.html {
        @compliance_controls = decorate_compliance_controls(@compliance_controls)
      }
    end
  end

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
  def decorate_compliance_controls(compliance_controls)
    ModelDecorator.decorate(
      compliance_controls,
      with: ComplianceControlDecorator,
    )
  end

  def compliance_control_params
    params.require(:compliance_control).permit(:name, :code, :criticity, :comment, :control_attributes)
  end
end
