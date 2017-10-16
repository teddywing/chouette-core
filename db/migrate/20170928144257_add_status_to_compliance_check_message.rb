class AddStatusToComplianceCheckMessage < ActiveRecord::Migration
  def change
    add_column :compliance_check_messages, :status, :string
  end
end
