class CreateComplianceCheckResources < ActiveRecord::Migration
  def change
    create_table :compliance_check_resources do |t|
      t.string :status
      t.string :name
      t.string :type
      t.string :reference
      t.hstore :metrics

      t.timestamps null: false
    end
  end
end
