class ComplianceControlBlocksController < BreadcrumbController
  defaults resource_class: ComplianceControlBlock
  belongs_to :compliance_control_set

  def new
    @compliance_control_set = parent
    @compliance_control_block = ComplianceControlBlock.new(compliance_control_set: @compliance_control_set)
  end

  def create
    create! do |success, failure|
      success.html { redirect_to compliance_control_set_path(@compliance_control_set) }  
      failure.html { render :action => :new }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to compliance_control_set_path(@compliance_control_set) }  
      failure.html { render :action => :edit }
    end 
  end

  private

  def create_resource compliance_control_block
    binding.pry
    compliance_control_block.transport_mode = params[:compliance_control_block][:transport_mode]
    super
  end

  def compliance_control_block_params
    params.require(:compliance_control_block).permit(:transport_mode)
  end

end