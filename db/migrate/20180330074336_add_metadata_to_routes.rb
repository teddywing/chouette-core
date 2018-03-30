class AddMetadataToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :metadata, :jsonb
  end
end
