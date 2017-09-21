class ChangeCrticityTypeForComplianceControl < ActiveRecord::Migration
  def change
    change_column :compliance_controls, :criticity, :string
  end
end
