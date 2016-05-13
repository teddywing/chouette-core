class AddLineReferentialToGroupOfLines < ActiveRecord::Migration
  def change
    add_reference :group_of_lines, :line_referential, index: true
  end
end
