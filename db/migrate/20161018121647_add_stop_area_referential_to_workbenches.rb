class AddStopAreaReferentialToWorkbenches < ActiveRecord::Migration
  def change
    add_reference :workbenches, :stop_area_referential, index: true
  end
end
