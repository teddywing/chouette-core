class AddOriginCodeToComplianceControls < ActiveRecord::Migration
  def change
    add_column :compliance_controls, :origin_code, :string
  end
end
