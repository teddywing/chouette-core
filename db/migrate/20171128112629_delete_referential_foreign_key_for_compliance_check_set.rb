class DeleteReferentialForeignKeyForComplianceCheckSet < ActiveRecord::Migration
  def up
    remove_foreign_key :compliance_check_sets, :referentials
  end

  def down
    add_foreign_key :compliance_check_sets, :referentials
  end
end
