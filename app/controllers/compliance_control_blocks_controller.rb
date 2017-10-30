class ComplianceControlBlocksController < InheritedResources::Base
  defaults resource_class: ComplianceControlBlock
  belongs_to :compliance_control_set
  actions :all, :except => [:show, :index]

  private

  def compliance_control_block_params
    params.require(:compliance_control_block).permit(:transport_mode, :transport_submode)
  end

end
