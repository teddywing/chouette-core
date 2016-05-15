class AddStopAreaReferentialToReferential < ActiveRecord::Migration
  def change
    add_reference :referentials, :stop_area_referential
  end
end
