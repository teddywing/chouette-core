class ChangeComplianceControlComplianceCheckControlAttributesFormatFromHstoreToJson < ActiveRecord::Migration
  def change
    change_column :compliance_controls,
      :control_attributes,
      'json USING hstore_to_json(control_attributes)'
    change_column :compliance_checks,
      :control_attributes,
      'json USING hstore_to_json(control_attributes)'
  end
end
