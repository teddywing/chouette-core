class AddCodeToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :code, :string
  end
end
