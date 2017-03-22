class SetDefaultValueForDataFormatInOrganisation < ActiveRecord::Migration
  def change
    Organisation.where(data_format: nil).update_all(data_format: "neptune")
    execute "update referentials set data_format = organisations.data_format from organisations where referentials.data_format is null and referentials.organisation_id = organisations.id"
    change_column :organisations, :data_format, :string, :default => "neptune"
  end
end
