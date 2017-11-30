class AddNotifyParentAtToComplianceCheckSets < ActiveRecord::Migration
  def change
    add_column :compliance_check_sets, :notified_parent_at, :datetime
  end
end
