class ComplianceControlBlocksController < BreadcrumbController
  defaults resource_class: ComplianceControlBlock
  belongs_to :compliance_control_set
  actions :all, :except => [:show, :index]

  def new
    @compliance_control_set = parent
    @compliance_control_block = ComplianceControlBlock.new(compliance_control_set: @compliance_control_set)
  end

  private

  def compliance_control_block_params
    params.require(:compliance_control_block).permit(:transport_mode, :transport_sub_mode)
  end

end