class ComplianceControlSetsController < BreadcrumbController

  defaults resource_class: ComplianceControlSet
  respond_to :html

  def index
    index! do
      @compliance_control_sets = decorate_compliance_control_sets(@compliance_control_sets)
      build_breadcrumb :show
    end
  end


  def decorate_compliance_control_sets(compliance_control_sets)
    ModelDecorator.decorate(
      compliance_control_sets,
      with: ComplianceControlSetDecorator
    )
  end

end
