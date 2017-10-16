class SetCodeUiquenessInComplianceControl < ActiveRecord::Migration
  def change
    add_index :compliance_controls, [:code, :compliance_control_set_id], unique: true
  end
end
