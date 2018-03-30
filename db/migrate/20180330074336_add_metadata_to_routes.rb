class AddMetadataToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :metadata, :json
  end
end
