class AddOfferWorkbenchToReferentials < ActiveRecord::Migration
  def change
    add_reference :referentials, :offer_workbench
  end
end
