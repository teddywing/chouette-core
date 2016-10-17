class AddSsoAttributesToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :sso_attributes, :hstore
  end
end
