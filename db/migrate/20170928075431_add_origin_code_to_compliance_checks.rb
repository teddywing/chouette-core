class AddOriginCodeToComplianceChecks < ActiveRecord::Migration
  def change
    add_column :compliance_checks, :origin_code, :string
  end
end
