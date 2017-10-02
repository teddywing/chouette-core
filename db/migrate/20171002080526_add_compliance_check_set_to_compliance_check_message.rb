class AddComplianceCheckSetToComplianceCheckMessage < ActiveRecord::Migration
  def change
    add_reference :compliance_check_messages, :compliance_check_set, index: true, foreign_key: true
  end
end
