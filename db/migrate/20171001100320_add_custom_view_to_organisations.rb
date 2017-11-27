class AddCustomViewToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :custom_view, :string
  end
end
