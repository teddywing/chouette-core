class RemoveStringToComplianceCheckSet < ActiveRecord::Migration
  def change
    remove_column :compliance_check_sets, :string, :string
  end
end
