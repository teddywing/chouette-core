class AddLineReferntialToNetworks < ActiveRecord::Migration
  def change
    add_reference :networks, :line_referential, index: true
  end
end
