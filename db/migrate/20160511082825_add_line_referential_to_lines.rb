class AddLineReferentialToLines < ActiveRecord::Migration
  def change
    add_reference :lines, :line_referential, index: true
  end
end
