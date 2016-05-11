class AddLineReferentialToStopAreas < ActiveRecord::Migration
  def change
    add_reference :stop_areas, :line_referential, index: true
  end
end
