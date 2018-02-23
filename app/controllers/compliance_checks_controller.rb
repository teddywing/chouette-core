class ComplianceChecksController <  InheritedResources::Base
  before_action do
    @workbench = Workbench.find params[:workbench_id]
  end

end
