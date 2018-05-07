class WorkgroupsController < ChouetteController
  defaults resource_class: Workgroup

  include PolicyChecker

  def show
    redirect_to "/"
  end

  def workgroup_params
    params[:workgroup].permit(workbenches_attributes: [:id, owner_compliance_control_set_ids: @workgroup.available_compliance_control_sets.keys])
  end
end
