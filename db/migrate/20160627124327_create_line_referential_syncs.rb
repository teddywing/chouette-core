class CreateLineReferentialSyncs < ActiveRecord::Migration
  def change
    create_table :line_referential_syncs do |t|
      t.references :line_referential, index: true

      t.timestamps
    end
  end
end
