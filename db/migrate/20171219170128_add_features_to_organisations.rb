class AddFeaturesToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :features, :string, array: true, default: []
  end
end
