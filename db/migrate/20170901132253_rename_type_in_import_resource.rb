class RenameTypeInImportResource < ActiveRecord::Migration
  def change
    rename_column :import_resources, :type, :resource_type
  end
end
