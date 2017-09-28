class RemoveComplianceControlFromComplianceControlBlock < ActiveRecord::Migration
  def change
    remove_reference :compliance_control_blocks, :compliance_control, index: true, foreign_key: true
  end
end
