class RemoveCreatorFromComplianceCheckSets < ActiveRecord::Migration
  def change
    remove_column :compliance_check_sets, :creator, :string
  end
end
