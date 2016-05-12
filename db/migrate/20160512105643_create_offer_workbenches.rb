class CreateOfferWorkbenches < ActiveRecord::Migration
  def change
    create_table :offer_workbenches do |t|
      t.string :name
      t.references :organisation, index: true

      t.timestamps
    end
  end
end
