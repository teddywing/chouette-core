class CreateImportResources < ActiveRecord::Migration
  def change
    create_table :import_resources do |t|
      t.references :import, index: true
      t.string :status

      t.timestamps
    end
  end
end
