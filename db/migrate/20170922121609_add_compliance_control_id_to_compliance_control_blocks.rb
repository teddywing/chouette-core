class AddComplianceControlIdToComplianceControlBlocks < ActiveRecord::Migration
  def change
    add_reference :compliance_control_blocks, :compliance_control, index: true, foreign_key: true
  end
end
