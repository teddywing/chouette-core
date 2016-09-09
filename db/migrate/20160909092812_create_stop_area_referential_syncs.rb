class CreateStopAreaReferentialSyncs < ActiveRecord::Migration
  def change
    create_table :stop_area_referential_syncs do |t|
      t.references :stop_area_referential, index: true

      t.timestamps
    end
  end
end
