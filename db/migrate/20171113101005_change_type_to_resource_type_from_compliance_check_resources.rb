class ChangeTypeToResourceTypeFromComplianceCheckResources < ActiveRecord::Migration
  def change
    rename_column :compliance_check_resources, :type, :resource_type
  end
end
