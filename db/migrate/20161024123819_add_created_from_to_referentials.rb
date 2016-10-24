class AddCreatedFromToReferentials < ActiveRecord::Migration
  def change
    add_reference :referentials, :created_from, index: true
  end
end
