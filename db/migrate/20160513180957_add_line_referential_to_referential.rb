class AddLineReferentialToReferential < ActiveRecord::Migration
  def change
    add_reference :referentials, :line_referential
  end
end
