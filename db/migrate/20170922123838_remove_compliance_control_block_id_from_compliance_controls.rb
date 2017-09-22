class RemoveComplianceControlBlockIdFromComplianceControls < ActiveRecord::Migration
  def change
    remove_reference :compliance_controls, :compliance_control_block, index: true, foreign_key: true
  end
end
