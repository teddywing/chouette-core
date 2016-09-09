class CreateLineSyncOperations < ActiveRecord::Migration
  def change
    create_table :line_sync_operations do |t|
      t.string :status
      t.references :line_referential_sync, index: true

      t.timestamps
    end
  end
end
