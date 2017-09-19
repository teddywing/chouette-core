class AlterTableComplianceCheckResultToComplianceCheckMessage < ActiveRecord::Migration
  def change
    rename_table :compliance_check_results, :compliance_check_messages
  end
end
