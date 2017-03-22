class AddOrganisationCodeIndex < ActiveRecord::Migration
  def change
    add_index :organisations, :code, unique: true
  end
end
