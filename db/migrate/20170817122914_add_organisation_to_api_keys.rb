class AddOrganisationToApiKeys < ActiveRecord::Migration
  def change
    add_reference :api_keys, :organisation, index: true, foreign_key: true
  end
end
