class WorkbenchOutputsController < ChouetteController
  respond_to :html, only: [:show]
  defaults resource_class: Workbench

  def show
    @workbench = current_organisation.workbenches.find params[:workbench_id]
    @workbench_merges = @workbench.merges.order("created_at desc").paginate(page: params[:page], per_page: 10)
  end
end
