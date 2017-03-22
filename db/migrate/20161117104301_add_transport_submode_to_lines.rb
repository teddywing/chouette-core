class AddTransportSubmodeToLines < ActiveRecord::Migration
  def change
    add_column :lines, :transport_submode, :string
  end
end
