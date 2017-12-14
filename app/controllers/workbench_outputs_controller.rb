class WorkbenchOutputsController < ChouetteController
  respond_to :html, only: [:show]
  defaults resource_class: Workbench

  def show
    @workbench = current_organisation.workbenches.find params[:workbench_id]
  end
end
