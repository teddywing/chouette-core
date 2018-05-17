class AlterImportResourceReferentialId < ActiveRecord::Migration
  def change
    change_column :import_resources, :referential_id, :bigint
  end
end
