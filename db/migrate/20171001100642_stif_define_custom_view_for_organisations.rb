class StifDefineCustomViewForOrganisations < ActiveRecord::Migration
  def change
    Organisation.update_all custom_view: "stif"
  end
end
