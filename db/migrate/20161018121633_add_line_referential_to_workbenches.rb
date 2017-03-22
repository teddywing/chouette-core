class AddLineReferentialToWorkbenches < ActiveRecord::Migration
  def change
    add_reference :workbenches, :line_referential, index: true
  end
end
