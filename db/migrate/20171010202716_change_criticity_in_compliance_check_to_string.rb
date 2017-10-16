class ChangeCriticityInComplianceCheckToString < ActiveRecord::Migration
  def change
    change_column :compliance_checks, :criticity, :string
  end
end
