class CreateComplianceControlSets < ActiveRecord::Migration
  def change
    create_table :compliance_control_sets do |t|
      t.string :name
      t.references :organisation, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
