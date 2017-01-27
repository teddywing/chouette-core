class AddReadyToReferentials < ActiveRecord::Migration
  def change
    add_column :referentials, :ready, :boolean, default: false
  end
end
