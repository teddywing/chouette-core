class CreateCleanUpResults < ActiveRecord::Migration
  def change
    create_table :clean_up_results do |t|
      t.string :message_key
      t.hstore :message_attributs
      t.references :clean_up, index: true
      t.timestamps
    end
  end
end
