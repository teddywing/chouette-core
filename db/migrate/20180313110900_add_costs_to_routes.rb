class AddCostsToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :costs, :json
  end
end
