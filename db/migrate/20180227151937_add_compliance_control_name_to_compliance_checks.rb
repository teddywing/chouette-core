class AddComplianceControlNameToComplianceChecks < ActiveRecord::Migration
  def change
    add_column :compliance_checks, :compliance_control_name, :string
  end
end
